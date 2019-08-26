public PlVers:__version =
{
	version = 5,
	filevers = "1.10.0.6270",
	date = "08/25/2018",
	time = "12:08:37"
};
new Float:NULL_VECTOR[3];
new String:NULL_STRING[4];
public Extension:__ext_core =
{
	name = "Core",
	file = "core",
	autoload = 0,
	required = 0,
};
new MaxClients;
public Extension:__ext_sdktools =
{
	name = "SDKTools",
	file = "sdktools.ext",
	autoload = 1,
	required = 1,
};
public Extension:__ext_sdkhooks =
{
	name = "SDKHooks",
	file = "sdkhooks.ext",
	autoload = 1,
	required = 1,
};
public Plugin:myinfo =
{
	name = "M18_Claymore_mine",
	description = "M18_Claymore_mine",
	author = "LeiMuu",
	version = "1.0",
	url = "https://steamcommunity.com/groups/Death_Squads_X_Armory"
};
new g_iBeaconBeam;
new g_iBeaconHalo;
new Float:g_fLastHeight[2048];
new Float:g_fTimeCheck[2048];
new g_iTimeCheckHeight[2048];
public void:__ext_core_SetNTVOptional()
{
	MarkNativeAsOptional("GetFeatureStatus");
	MarkNativeAsOptional("RequireFeature");
	MarkNativeAsOptional("AddCommandListener");
	MarkNativeAsOptional("RemoveCommandListener");
	MarkNativeAsOptional("BfWriteBool");
	MarkNativeAsOptional("BfWriteByte");
	MarkNativeAsOptional("BfWriteChar");
	MarkNativeAsOptional("BfWriteShort");
	MarkNativeAsOptional("BfWriteWord");
	MarkNativeAsOptional("BfWriteNum");
	MarkNativeAsOptional("BfWriteFloat");
	MarkNativeAsOptional("BfWriteString");
	MarkNativeAsOptional("BfWriteEntity");
	MarkNativeAsOptional("BfWriteAngle");
	MarkNativeAsOptional("BfWriteCoord");
	MarkNativeAsOptional("BfWriteVecCoord");
	MarkNativeAsOptional("BfWriteVecNormal");
	MarkNativeAsOptional("BfWriteAngles");
	MarkNativeAsOptional("BfReadBool");
	MarkNativeAsOptional("BfReadByte");
	MarkNativeAsOptional("BfReadChar");
	MarkNativeAsOptional("BfReadShort");
	MarkNativeAsOptional("BfReadWord");
	MarkNativeAsOptional("BfReadNum");
	MarkNativeAsOptional("BfReadFloat");
	MarkNativeAsOptional("BfReadString");
	MarkNativeAsOptional("BfReadEntity");
	MarkNativeAsOptional("BfReadAngle");
	MarkNativeAsOptional("BfReadCoord");
	MarkNativeAsOptional("BfReadVecCoord");
	MarkNativeAsOptional("BfReadVecNormal");
	MarkNativeAsOptional("BfReadAngles");
	MarkNativeAsOptional("BfGetNumBytesLeft");
	MarkNativeAsOptional("BfWrite.WriteBool");
	MarkNativeAsOptional("BfWrite.WriteByte");
	MarkNativeAsOptional("BfWrite.WriteChar");
	MarkNativeAsOptional("BfWrite.WriteShort");
	MarkNativeAsOptional("BfWrite.WriteWord");
	MarkNativeAsOptional("BfWrite.WriteNum");
	MarkNativeAsOptional("BfWrite.WriteFloat");
	MarkNativeAsOptional("BfWrite.WriteString");
	MarkNativeAsOptional("BfWrite.WriteEntity");
	MarkNativeAsOptional("BfWrite.WriteAngle");
	MarkNativeAsOptional("BfWrite.WriteCoord");
	MarkNativeAsOptional("BfWrite.WriteVecCoord");
	MarkNativeAsOptional("BfWrite.WriteVecNormal");
	MarkNativeAsOptional("BfWrite.WriteAngles");
	MarkNativeAsOptional("BfRead.ReadBool");
	MarkNativeAsOptional("BfRead.ReadByte");
	MarkNativeAsOptional("BfRead.ReadChar");
	MarkNativeAsOptional("BfRead.ReadShort");
	MarkNativeAsOptional("BfRead.ReadWord");
	MarkNativeAsOptional("BfRead.ReadNum");
	MarkNativeAsOptional("BfRead.ReadFloat");
	MarkNativeAsOptional("BfRead.ReadString");
	MarkNativeAsOptional("BfRead.ReadEntity");
	MarkNativeAsOptional("BfRead.ReadAngle");
	MarkNativeAsOptional("BfRead.ReadCoord");
	MarkNativeAsOptional("BfRead.ReadVecCoord");
	MarkNativeAsOptional("BfRead.ReadVecNormal");
	MarkNativeAsOptional("BfRead.ReadAngles");
	MarkNativeAsOptional("BfRead.GetNumBytesLeft");
	MarkNativeAsOptional("PbReadInt");
	MarkNativeAsOptional("PbReadFloat");
	MarkNativeAsOptional("PbReadBool");
	MarkNativeAsOptional("PbReadString");
	MarkNativeAsOptional("PbReadColor");
	MarkNativeAsOptional("PbReadAngle");
	MarkNativeAsOptional("PbReadVector");
	MarkNativeAsOptional("PbReadVector2D");
	MarkNativeAsOptional("PbGetRepeatedFieldCount");
	MarkNativeAsOptional("PbSetInt");
	MarkNativeAsOptional("PbSetFloat");
	MarkNativeAsOptional("PbSetBool");
	MarkNativeAsOptional("PbSetString");
	MarkNativeAsOptional("PbSetColor");
	MarkNativeAsOptional("PbSetAngle");
	MarkNativeAsOptional("PbSetVector");
	MarkNativeAsOptional("PbSetVector2D");
	MarkNativeAsOptional("PbAddInt");
	MarkNativeAsOptional("PbAddFloat");
	MarkNativeAsOptional("PbAddBool");
	MarkNativeAsOptional("PbAddString");
	MarkNativeAsOptional("PbAddColor");
	MarkNativeAsOptional("PbAddAngle");
	MarkNativeAsOptional("PbAddVector");
	MarkNativeAsOptional("PbAddVector2D");
	MarkNativeAsOptional("PbRemoveRepeatedFieldValue");
	MarkNativeAsOptional("PbReadMessage");
	MarkNativeAsOptional("PbReadRepeatedMessage");
	MarkNativeAsOptional("PbAddMessage");
	MarkNativeAsOptional("Protobuf.ReadInt");
	MarkNativeAsOptional("Protobuf.ReadFloat");
	MarkNativeAsOptional("Protobuf.ReadBool");
	MarkNativeAsOptional("Protobuf.ReadString");
	MarkNativeAsOptional("Protobuf.ReadColor");
	MarkNativeAsOptional("Protobuf.ReadAngle");
	MarkNativeAsOptional("Protobuf.ReadVector");
	MarkNativeAsOptional("Protobuf.ReadVector2D");
	MarkNativeAsOptional("Protobuf.GetRepeatedFieldCount");
	MarkNativeAsOptional("Protobuf.SetInt");
	MarkNativeAsOptional("Protobuf.SetFloat");
	MarkNativeAsOptional("Protobuf.SetBool");
	MarkNativeAsOptional("Protobuf.SetString");
	MarkNativeAsOptional("Protobuf.SetColor");
	MarkNativeAsOptional("Protobuf.SetAngle");
	MarkNativeAsOptional("Protobuf.SetVector");
	MarkNativeAsOptional("Protobuf.SetVector2D");
	MarkNativeAsOptional("Protobuf.AddInt");
	MarkNativeAsOptional("Protobuf.AddFloat");
	MarkNativeAsOptional("Protobuf.AddBool");
	MarkNativeAsOptional("Protobuf.AddString");
	MarkNativeAsOptional("Protobuf.AddColor");
	MarkNativeAsOptional("Protobuf.AddAngle");
	MarkNativeAsOptional("Protobuf.AddVector");
	MarkNativeAsOptional("Protobuf.AddVector2D");
	MarkNativeAsOptional("Protobuf.RemoveRepeatedFieldValue");
	MarkNativeAsOptional("Protobuf.ReadMessage");
	MarkNativeAsOptional("Protobuf.ReadRepeatedMessage");
	MarkNativeAsOptional("Protobuf.AddMessage");
	VerifyCoreVersion();
	return void:0;
}

RoundFloat(Float:value)
{
	return RoundToNearest(value);
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

Handle:CreateDataTimer(Float:interval, Timer:func, &Handle:datapack, flags)
{
	datapack = DataPack.DataPack();
	flags |= 512;
	return CreateTimer(interval, func, datapack, flags);
}

bool:GetEntityClassname(entity, String:clsname[], maxlength)
{
	return !!GetEntPropString(entity, PropType:1, "m_iClassname", clsname, maxlength, 0);
}

void:EmitSoundToAll(String:sample[], entity, channel, level, flags, Float:volume, pitch, speakerentity, Float:origin[3], Float:dir[3], bool:updatePos, Float:soundtime)
{
	new clients[MaxClients];
	new total;
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			total++;
			clients[total] = i;
		}
		i++;
	}
	if (!total)
	{
		return void:0;
	}
	EmitSound(clients, total, sample, entity, channel, level, flags, volume, pitch, speakerentity, origin, dir, updatePos, soundtime);
	return void:0;
}

void:TE_SendToAll(Float:delay)
{
	new total;
	new clients[MaxClients];
	new i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			total++;
			clients[total] = i;
		}
		i++;
	}
	TE_Send(clients, total, delay);
	return void:0;
}

void:TE_SetupBeamRingPoint(Float:center[3], Float:Start_Radius, Float:End_Radius, ModelIndex, HaloIndex, StartFrame, FrameRate, Float:Life, Float:Width, Float:Amplitude, Color[4], Speed, Flags)
{
	TE_Start("BeamRingPoint");
	TE_WriteVector("m_vecCenter", center);
	TE_WriteFloat("m_flStartRadius", Start_Radius);
	TE_WriteFloat("m_flEndRadius", End_Radius);
	TE_WriteNum("m_nModelIndex", ModelIndex);
	TE_WriteNum("m_nHaloIndex", HaloIndex);
	TE_WriteNum("m_nStartFrame", StartFrame);
	TE_WriteNum("m_nFrameRate", FrameRate);
	TE_WriteFloat("m_fLife", Life);
	TE_WriteFloat("m_fWidth", Width);
	TE_WriteFloat("m_fEndWidth", Width);
	TE_WriteFloat("m_fAmplitude", Amplitude);
	TE_WriteNum("r", Color[0]);
	TE_WriteNum("g", Color[1]);
	TE_WriteNum("b", Color[2]);
	TE_WriteNum("a", Color[3]);
	TE_WriteNum("m_nSpeed", Speed);
	TE_WriteNum("m_nFlags", Flags);
	TE_WriteNum("m_nFadeLength", 0);
	return void:0;
}

public void:OnPluginStart()
{
	CreateConVar("DS_Ins_Claymore_mine", "1.0", "M18_Claymore_mine", 131328, false, 0.0, false, 0.0);
	HookEvent("round_end", Event_RoundEnd, EventHookMode:1);
	HookEvent("grenade_thrown", Event_GrenadeThrown, EventHookMode:1);
	return void:0;
}

public void:OnPluginEnd()
{
	new ent = -1;
	while ((ent = FindEntityByClassname(ent, "grenade_m18a1")) > MaxClients && IsValidEntity(ent))
	{
		AcceptEntityInput(ent, "Kill", -1, -1, 0);
	}
	return void:0;
}

public void:OnMapStart()
{
	g_iBeaconBeam = PrecacheModel("sprites/laserbeam.vmt", false);
	g_iBeaconHalo = PrecacheModel("sprites/halo01.vmt", false);
	PrecacheSound("soundscape/emitters/oneshot/radio_explode.ogg", false);
	PrecacheSound("ui/sfx/cl_click.wav", false);
	PrecacheSound("player/voice/insurgents/command/leader/spread1.ogg", false);
	PrecacheSound("player/voice/insurgents/command/leader/spread2.ogg", false);
	PrecacheSound("player/voice/insurgents/command/leader/spread3.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/leader/unsuppressed/c4out3.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/leader/unsuppressed/c4out4.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/leader/unsuppressed/c4out6.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/leader/unsuppressed/c4out10.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4out3.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4out4.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4out6.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4out10.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted1.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted2.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted3.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted4.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted5.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted6.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted7.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted8.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted9.ogg", false);
	PrecacheSound("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted10.ogg", false);
	PrecacheSound("player/voice/botsurvival/leader/incominggrenade5.ogg", false);
	PrecacheSound("player/voice/botsurvival/leader/incominggrenade16.ogg", false);
	PrecacheSound("player/voice/botsurvival/subordinate/incominggrenade16.ogg", false);
	PrecacheSound("player/voice/botsurvival/leader/incominggrenade18.ogg", false);
	PrecacheSound("player/voice/bot/leader/incominggrenade5.ogg", false);
	PrecacheSound("player/voice/bot/leader/incominggrenade16.ogg", false);
	PrecacheSound("player/voice/bot/subordinate/incominggrenade16.ogg", false);
	PrecacheSound("player/voice/bot/leader/incominggrenade18.ogg", false);
	return void:0;
}

public Action:Event_RoundEnd(Handle:event, String:name[], bool:dontBroadcast)
{
	new ent = -1;
	while ((ent = FindEntityByClassname(ent, "grenade_m18a1")) > MaxClients && IsValidEntity(ent))
	{
		AcceptEntityInput(ent, "Kill", -1, -1, 0);
	}
	return Action:0;
}

public Action:Event_GrenadeThrown(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new nade_id = GetEventInt(event, "entityid", 0);
	new var1;
	if (nade_id > -1 && client > -1)
	{
		if (IsPlayerAlive(client))
		{
			decl String:grenade_name[32];
			GetEntityClassname(nade_id, grenade_name, 32);
			if (StrEqual(grenade_name, "grenade_m18a1", true))
			{
				switch (GetRandomInt(1, 21))
				{
					case 1:
					{
						EmitSoundToAll("player/voice/insurgents/command/leader/spread1.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 2:
					{
						EmitSoundToAll("player/voice/insurgents/command/leader/spread2.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 3:
					{
						EmitSoundToAll("player/voice/insurgents/command/leader/spread3.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 4:
					{
						EmitSoundToAll("player/voice/responses/insurgent/leader/unsuppressed/c4out3.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 5:
					{
						EmitSoundToAll("player/voice/responses/insurgent/leader/unsuppressed/c4out4.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 6:
					{
						EmitSoundToAll("player/voice/responses/insurgent/leader/unsuppressed/c4out6.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 7:
					{
						EmitSoundToAll("player/voice/responses/insurgent/leader/unsuppressed/c4out10.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 8:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4out3.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 9:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4out4.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 10:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4out6.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 11:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4out10.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 12:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted1.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 13:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted2.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 14:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted3.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 15:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted4.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 16:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted5.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 17:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted6.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 18:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted7.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 19:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted8.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 20:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted9.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 21:
					{
						EmitSoundToAll("player/voice/responses/insurgent/subordinate/unsuppressed/c4planted10.ogg", client, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					default:
					{
					}
				}
			}
		}
	}
	return Action:0;
}

public void:OnEntityCreated(entity, String:classname[])
{
	if (StrEqual(classname, "grenade_m18a1", true))
	{
		new Handle:hDatapack;
		CreateDataTimer(1.0, Claymore, hDatapack, 3);
		WritePackCell(hDatapack, entity);
		WritePackFloat(hDatapack, GetGameTime() + 150.0);
		g_fLastHeight[entity] = -971228160;
		g_iTimeCheckHeight[entity] = -9999;
		SDKHook(entity, SDKHookType:27, ClaymoreGroundCheck);
		CreateTimer(0.1, ClaymoreGroundCheckTimer, entity, 3);
	}
	return void:0;
}

public Action:ClaymoreGroundCheck(entity, activator, caller, UseType:type, Float:value)
{
	new Float:fOrigin[3] = 0.0;
	GetEntPropVector(entity, PropType:0, "m_vecOrigin", fOrigin, 0);
	new iRoundHeight = RoundFloat(fOrigin[2]);
	if (g_iTimeCheckHeight[entity] != iRoundHeight)
	{
		g_iTimeCheckHeight[entity] = iRoundHeight;
		g_fTimeCheck[entity] = GetGameTime();
	}
	return Action:0;
}

public Action:ClaymoreGroundCheckTimer(Handle:timer, any:entity)
{
	new var1;
	if (entity > MaxClients && IsValidEntity(entity))
	{
		new Float:fGameTime = GetGameTime();
		if (fGameTime - g_fTimeCheck[entity] >= 1.0)
		{
			new Float:fOrigin[3] = 0.0;
			GetEntPropVector(entity, PropType:0, "m_vecOrigin", fOrigin, 0);
			new iRoundHeight = RoundFloat(fOrigin[2]);
			if (g_iTimeCheckHeight[entity] == iRoundHeight)
			{
				g_fTimeCheck[entity] = GetGameTime();
				SDKUnhook(entity, SDKHookType:27, ClaymoreGroundCheck);
				SDKHook(entity, SDKHookType:27, OnEntityPhysicsUpdate);
				KillTimer(timer, false);
			}
		}
	}
	else
	{
		KillTimer(timer, false);
	}
	return Action:0;
}

public Action:OnEntityPhysicsUpdate(entity, activator, caller, UseType:type, Float:value)
{
	TeleportEntity(entity, NULL_VECTOR, NULL_VECTOR, 30928);
	return Action:0;
}

public Action:Claymore(Handle:timer, Handle:hDatapack)
{
	ResetPack(hDatapack, false);
	new entity = ReadPackCell(hDatapack);
	new Float:fEndTime = ReadPackFloat(hDatapack);
	new Float:fGameTime = GetGameTime();
	new var1;
	if (entity > 0 && IsValidEntity(entity) && fGameTime <= fEndTime)
	{
		new Float:fOrigin[3] = 0.0;
		GetEntPropVector(entity, PropType:0, "m_vecOrigin", fOrigin, 0);
		if (-9999.0 == g_fLastHeight[entity])
		{
			g_fLastHeight[entity] = 0;
		}
		fOrigin[2] += 16.0;
		TE_SetupBeamRingPoint(fOrigin, 10.0, 1.95 * 150.0, g_iBeaconBeam, g_iBeaconHalo, 0, 10, 0.6, 3.0, 0.0, 30952, 1, 0);
		TE_SendToAll(0.0);
		fOrigin[2] -= 16.0;
		if (fOrigin[2] != g_fLastHeight[entity])
		{
			g_fLastHeight[entity] = fOrigin[2];
		}
		else
		{
			new Float:fAng[3] = 0.0;
			GetEntPropVector(entity, PropType:0, "m_angRotation", fAng, 0);
			new var2;
			if (fAng[1] > 89.0 || fAng[1] < -89.0)
			{
				fAng[1] = 90.0;
			}
			new var3;
			if (fAng[2] > 89.0 || fAng[2] < -89.0)
			{
				fAng[2] = 0.0;
				fOrigin[2] -= 6.0;
				TeleportEntity(entity, fOrigin, fAng, 30984);
				fOrigin[2] += 6.0;
				EmitSoundToAll("ui/sfx/cl_click.wav", entity, 6, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
			}
		}
		new iPlayer = 1;
		while (iPlayer <= MaxClients)
		{
			new var4;
			if (IsClientInGame(iPlayer) && IsPlayerAlive(iPlayer))
			{
				decl Float:fPlayerOrigin[3];
				GetClientEyePosition(iPlayer, fPlayerOrigin);
				if (GetVectorDistance(fPlayerOrigin, fOrigin, false) <= 150.0)
				{
					new Handle:hData = CreateDataPack();
					WritePackCell(hData, entity);
					WritePackCell(hData, iPlayer);
					fOrigin[2] += 32.0;
					new Handle:trace = TR_TraceRayFilterEx(fPlayerOrigin, fOrigin, 33570827, RayType:0, Filter_ClientSelf, hData);
					CloseHandle(hData);
					if (!TR_DidHit(trace))
					{
						DealDamage(entity, 100, iPlayer, 64, "grenade_m18a1");
					}
				}
			}
			iPlayer++;
		}
	}
	else
	{
		RemoveClaymore(entity);
		KillTimer(timer, false);
	}
	return Action:0;
}

DealDamage(victim, damage, attacker, dmg_type, String:weapon[])
{
	new var1;
	if (victim > 0 && IsValidEdict(victim) && damage > 0)
	{
		decl String:dmg_str[16];
		IntToString(damage, dmg_str, 16);
		decl String:dmg_type_str[32];
		IntToString(dmg_type, dmg_type_str, 32);
		new pointHurt = CreateEntityByName("point_hurt", -1);
		if (pointHurt)
		{
			DispatchKeyValue(victim, "targetname", "hurtme");
			DispatchKeyValue(pointHurt, "DamageTarget", "hurtme");
			DispatchKeyValue(pointHurt, "Damage", dmg_str);
			DispatchKeyValue(pointHurt, "DamageType", dmg_type_str);
			if (!StrEqual(weapon, "", true))
			{
				DispatchKeyValue(pointHurt, "classname", weapon);
			}
			DispatchSpawn(pointHurt);
			if (GetClientTeam(attacker) == 2)
			{
				switch (GetRandomInt(1, 4))
				{
					case 1:
					{
						EmitSoundToAll("player/voice/bot/leader/incominggrenade5.ogg", attacker, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 2:
					{
						EmitSoundToAll("player/voice/bot/leader/incominggrenade16.ogg", attacker, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 3:
					{
						EmitSoundToAll("player/voice/bot/subordinate/incominggrenade16.ogg", attacker, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					case 4:
					{
						EmitSoundToAll("player/voice/bot/leader/incominggrenade18.ogg", attacker, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
					}
					default:
					{
					}
				}
			}
			else
			{
				if (GetClientTeam(attacker) == 3)
				{
					switch (GetRandomInt(1, 4))
					{
						case 1:
						{
							EmitSoundToAll("player/voice/botsurvival/leader/incominggrenade5.ogg", attacker, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
						}
						case 2:
						{
							EmitSoundToAll("player/voice/botsurvival/leader/incominggrenade16.ogg", attacker, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
						}
						case 3:
						{
							EmitSoundToAll("player/voice/botsurvival/subordinate/incominggrenade16.ogg", attacker, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
						}
						case 4:
						{
							EmitSoundToAll("player/voice/botsurvival/leader/incominggrenade18.ogg", attacker, 2, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
						}
						default:
						{
						}
					}
				}
			}
			AcceptEntityInput(pointHurt, "Hurt", -1, -1, 0);
			DispatchKeyValue(pointHurt, "classname", "point_hurt");
			DispatchKeyValue(victim, "targetname", "donthurtme");
			RemoveEdict(pointHurt);
		}
	}
	return 0;
}

public bool:Filter_ClientSelf(entity, contentsMask, any:data)
{
	ResetPack(data, false);
	new client = ReadPackCell(data);
	new player = ReadPackCell(data);
	new var1;
	if (client != entity && player != entity)
	{
		return true;
	}
	return false;
}

public RemoveClaymore(entity)
{
	new var1;
	if (entity > MaxClients && IsValidEntity(entity))
	{
		EmitSoundToAll("soundscape/emitters/oneshot/radio_explode.ogg", entity, 6, 75, 0, 1.0, 100, -1, NULL_VECTOR, NULL_VECTOR, true, 0.0);
		new dissolver = CreateEntityByName("env_entity_dissolver", -1);
		if (dissolver != -1)
		{
			DispatchKeyValue(dissolver, "dissolvetype", "1");
			DispatchKeyValue(dissolver, "magnitude", "1");
			DispatchKeyValue(dissolver, "target", "!activator");
			AcceptEntityInput(dissolver, "Dissolve", entity, -1, 0);
			AcceptEntityInput(dissolver, "Kill", -1, -1, 0);
		}
	}
	return 0;
}