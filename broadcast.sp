/*
broadcast.sp

Description:
	The Broadcast! plugin allows players to broadcast different words per round.

Versions:
	1.0
		* Initial Release
		
	1.1
		* Added cvar to control colors
		* Added cvar to control chat
		* Added team color to name
		
	1.2
		* Added jeers
		* Added admin only support for jeers
		* Made config file autoload
		
	1.3
		* Added *DEAD* in front of dead people's jeers
		* Added volume control cvar sm_cheer_jeer_volume
		* Added jeer limit cvat sm_cheer_jeer_limit
		* Added count infomation to limit displays
*/


#include <sourcemod>
#include <sdktools>

#pragma semicolon 1

#define PLUGIN_VERSION "1.4"
#define NUM_SOUNDS 12

// Plugin definitions
public Plugin:myinfo = 
{
	name = "Broadcast!",
	author = "LeiMuu",
	description = "The Broadcast! plugin allows players to broadcast different words per round.",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net"
};

new g_cheerCount[MAXPLAYERS + 1];
new g_jeerCount[MAXPLAYERS + 1];
new g_helpCount[MAXPLAYERS + 1];
new g_fuckCount[MAXPLAYERS + 1];
new g_dawaeCount[MAXPLAYERS + 1];
new Handle:g_CvarEnabled = INVALID_HANDLE;
new Handle:g_CvarMaxCheers = INVALID_HANDLE;
new Handle:g_CvarMaxhelps = INVALID_HANDLE;
new Handle:g_CvarMaxfucks = INVALID_HANDLE;
new Handle:g_CvarMaxdawaes = INVALID_HANDLE;
new Handle:g_CvarChat = INVALID_HANDLE;
new Handle:g_CvarColors = INVALID_HANDLE;
new Handle:g_CvarJeer = INVALID_HANDLE;
new Handle:g_CvarMaxJeers = INVALID_HANDLE;
new Handle:g_CvarJeerVolume = INVALID_HANDLE;
new Handle:g_CvarCheerVolume = INVALID_HANDLE;
new Handle:g_CvarHelpVolume = INVALID_HANDLE;
new Handle:g_CvarFuckVolume = INVALID_HANDLE;
new Handle:g_CvarDawaeVolume = INVALID_HANDLE;
new String:g_soundsList[NUM_SOUNDS][PLATFORM_MAX_PATH];
new String:g_soundsListJeer[NUM_SOUNDS][PLATFORM_MAX_PATH];
new String:g_helpList[NUM_SOUNDS][PLATFORM_MAX_PATH];
new String:g_fuckList[NUM_SOUNDS][PLATFORM_MAX_PATH];
new String:g_dawaeList[NUM_SOUNDS][PLATFORM_MAX_PATH];
new String:g_particleList[NUM_SOUNDS][PLATFORM_MAX_PATH];
new String:g_customList[NUM_SOUNDS][PLATFORM_MAX_PATH];

public OnPluginStart()
{
	CreateConVar("sm_cheer_version", PLUGIN_VERSION, "Cheer Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	g_CvarEnabled = CreateConVar("sm_cheer_enable", "1", "Enables the Cheer! plugin");
	g_CvarMaxCheers = CreateConVar("sm_cheer_limit", "3", "The maximum number of cheers per round");
	g_CvarMaxhelps = CreateConVar("sm_help_limit", "3", "The maximum number of helps per round");
	g_CvarMaxfucks = CreateConVar("sm_fuck_limit", "3", "The maximum number of fucks per round");
	g_CvarMaxdawaes = CreateConVar("sm_dawae_limit", "3", "The maximum number of dawaes per round");
	g_CvarColors = CreateConVar("sm_cheer_colors", "1", "1 to turn chat colors on, 0 for off");
	g_CvarChat = CreateConVar("sm_cheer_chat", "1", "1 to turn enable chat messages, 0 for off");
	g_CvarJeer = CreateConVar("sm_cheer_jeer", "1", "0 to disable jeers when dead, 1 to enable for all, 2 for admin only");
	g_CvarMaxJeers = CreateConVar("sm_cheer_jeer_limit", "1", "The maximum number of jeers per round");
	g_CvarJeerVolume = CreateConVar("sm_cheer_jeer_volume", "1.0", "Jeer volume: should be a number between 0.0. and 1.0");
	g_CvarCheerVolume = CreateConVar("sm_cheer_volume", "1.0", "Cheer volume: should be a number between 0.0. and 1.0");
	g_CvarHelpVolume = CreateConVar("sm_help_volume", "1.0", "Help volume: should be a number between 0.0. and 1.0");
	g_CvarFuckVolume = CreateConVar("sm_fuck_volume", "1.0", "Fuck volume: should be a number between 0.0. and 1.0");
	g_CvarDawaeVolume = CreateConVar("sm_dawae_volume", "1.0", "Dawae volume: should be a number between 0.0. and 1.0");
	
	// Execute the config file
	AutoExecConfig(true, "broadcast");
	
	LoadTranslations("plugin.broadcast");
	
	LoadSounds();
	
	HookEvent("round_start", EventRoundStart, EventHookMode_PostNoCopy);
	RegConsoleCmd("cheer", CommandCheer);
	RegConsoleCmd("helpme", CommandHelp);
	RegConsoleCmd("fuck", CommandFuck);
	RegConsoleCmd("dawae", CommandDawae);
}

public OnMapStart()
{
	for(new sound=0; sound < NUM_SOUNDS; sound++)
	{
		decl String:downloadFile[PLATFORM_MAX_PATH];
	
		if(!StrEqual(g_soundsList[sound], ""))
		{
			PrecacheSound(g_soundsList[sound], true);
			Format(downloadFile, PLATFORM_MAX_PATH, "sound/%s", g_soundsList[sound]);
			AddFileToDownloadsTable(downloadFile);
		}
		if(!StrEqual(g_soundsListJeer[sound], ""))
		{
			PrecacheSound(g_soundsListJeer[sound], true);
			Format(downloadFile, PLATFORM_MAX_PATH, "sound/%s", g_soundsListJeer[sound]);
			AddFileToDownloadsTable(downloadFile);
		}
		if(!StrEqual(g_helpList[sound], ""))
		{
			PrecacheSound(g_helpList[sound], true);
			Format(downloadFile, PLATFORM_MAX_PATH, "sound/%s", g_helpList[sound]);
			AddFileToDownloadsTable(downloadFile);
		}
		if(!StrEqual(g_fuckList[sound], ""))
		{
			PrecacheSound(g_fuckList[sound], true);
			Format(downloadFile, PLATFORM_MAX_PATH, "sound/%s", g_fuckList[sound]);
			AddFileToDownloadsTable(downloadFile);
		}
		if(!StrEqual(g_dawaeList[sound], ""))
		{
			PrecacheSound(g_dawaeList[sound], true);
			Format(downloadFile, PLATFORM_MAX_PATH, "sound/%s", g_dawaeList[sound]);
			AddFileToDownloadsTable(downloadFile);
		}
		if(!StrEqual(g_particleList[sound], ""))
		{
			PrecacheGeneric(g_particleList[sound], true);
			Format(downloadFile, PLATFORM_MAX_PATH, "custom/workshop/particles/%s", g_particleList[sound]);
			AddFileToDownloadsTable(downloadFile);
		}
		if(!StrEqual(g_customList[sound], ""))
		{
			PrecacheGeneric(g_customList[sound], true);
			Format(downloadFile, PLATFORM_MAX_PATH, "custom/%s", g_customList[sound]);
			AddFileToDownloadsTable(downloadFile);
		}
	}
}

// When a new client is put in the server we reset their cheer count
public OnClientPutInServer(client)
{
	if(client && !IsFakeClient(client))
	{
		g_cheerCount[client] = 0;
		g_jeerCount[client] = 0;
		g_helpCount[client] = 0;
		g_fuckCount[client] = 0;
		g_dawaeCount[client] = 0;
	}
}

public Action:CommandCheer(client, args)
{
	if(!GetConVarBool(g_CvarEnabled))
	{
		return Plugin_Handled;
	}
	
	if(!client || !IsClientInGame(client))
	{
		return Plugin_Handled;
	}
	
	
	if(IsPlayerAlive(client))
	{
		if(g_cheerCount[client] >= GetConVarInt(g_CvarMaxCheers))
		{
			PrintToChat(client, "%t", "over cheer limit", GetConVarInt(g_CvarMaxCheers));
			return Plugin_Handled;
		}
		new Float:vec[3];
		GetClientEyePosition(client, vec);
		EmitAmbientSound(g_soundsList[GetRandomInt(0, 11)], vec, SOUND_FROM_WORLD, SNDLEVEL_SCREAMING, _, GetConVarFloat(g_CvarCheerVolume));
		if(GetConVarBool(g_CvarChat))
		{
			decl String:name[50];
			GetClientName(client, name, sizeof(name));
			if(GetConVarBool(g_CvarColors))
			{
				new Handle:hMessage = StartMessageAll("SayText2");
				BfWriteByte(hMessage, client);
				BfWriteByte(hMessage, true);
				BfWriteString(hMessage, "\x03%s1 \x04cheered!!!");
				BfWriteString(hMessage, name);
				EndMessage();
			} else {
				PrintToChatAll("%s cheered!!", name);
			}
		}
		g_cheerCount[client]++;
	} else {
		// the player is dead
		if(g_jeerCount[client] >= GetConVarInt(g_CvarMaxJeers))
		{
			PrintToChat(client, "%t", "over jeer limit", GetConVarInt(g_CvarMaxJeers));
			return Plugin_Handled;
		}
		if(GetConVarInt(g_CvarJeer) == 1 || (GetConVarInt(g_CvarJeer) == 2 && GetUserAdmin(client) != INVALID_ADMIN_ID))
		{
			for(new i = 1; i <= GetMaxClients(); i++)
			{
				if(IsClientInGame(i) && !IsFakeClient(i))
				{
					EmitSoundToClient(i, g_soundsListJeer[GetRandomInt(0, 11)], _, _, _, _, GetConVarFloat(g_CvarJeerVolume));
				}
			}
			if(GetConVarBool(g_CvarChat))
			{
				decl String:team[10];
				team = GetClientTeam(client) > 1 ? "DEAD" : "SPEC";
				decl String:name[50];
				GetClientName(client, name, sizeof(name));
				if(GetConVarBool(g_CvarColors))
				{
					new Handle:hMessage = StartMessageAll("SayText2");
					BfWriteByte(hMessage, client);
					BfWriteByte(hMessage, true);
					BfWriteString(hMessage, "\x01*%s1* \x03%s2 \x04jeered!!!");
					BfWriteString(hMessage, team);
					BfWriteString(hMessage, name);
					EndMessage();
				} else {
					PrintToChatAll("*%s* %s jeered!!", team, name);
				}
			}
			g_jeerCount[client]++;
		} else {
			PrintToChat(client, "%t", "dead cant cheer");
		}
	}
	
	return Plugin_Handled;
}

public Action:CommandHelp(client, args)
{
	if(!GetConVarBool(g_CvarEnabled))
	{
		return Plugin_Handled;
	}
	
	if(!client || !IsClientInGame(client))
	{
		return Plugin_Handled;
	}
	
	
	if(IsPlayerAlive(client))
	{
		if(g_helpCount[client] >= GetConVarInt(g_CvarMaxhelps))
		{
			PrintToChat(client, "%t", "over help limit", GetConVarInt(g_CvarMaxhelps));
			return Plugin_Handled;
		}
		new Float:vec[3];
		GetClientEyePosition(client, vec);
		EmitAmbientSound(g_helpList[GetRandomInt(0, 11)], vec, SOUND_FROM_WORLD, SNDLEVEL_SCREAMING, _, GetConVarFloat(g_CvarHelpVolume));
		if(GetConVarBool(g_CvarChat))
		{
			decl String:name[50];
			GetClientName(client, name, sizeof(name));
			if(GetConVarBool(g_CvarColors))
			{
				new Handle:hMessage = StartMessageAll("SayText2");
				BfWriteByte(hMessage, client);
				BfWriteByte(hMessage, true);
				BfWriteString(hMessage, "\x03%s1 \x04help!!!");
				BfWriteString(hMessage, name);
				EndMessage();
			} else {
				PrintToChatAll("%s help!!", name);
			}
		}
		g_helpCount[client]++;
	} else {
		// the player is dead
		if(g_helpCount[client] >= GetConVarInt(g_CvarMaxhelps))
		{
			PrintToChat(client, "%t", "over help limit", GetConVarInt(g_CvarMaxhelps));
			return Plugin_Handled;
		}
		if(GetConVarInt(g_CvarJeer) == 1 || (GetConVarInt(g_CvarJeer) == 2 && GetUserAdmin(client) != INVALID_ADMIN_ID))
		{
			for(new i = 1; i <= GetMaxClients(); i++)
			{
				if(IsClientInGame(i) && !IsFakeClient(i))
				{
					EmitSoundToClient(i, g_helpList[GetRandomInt(0, 11)], _, _, _, _, GetConVarFloat(g_CvarHelpVolume));
				}
			}
			if(GetConVarBool(g_CvarChat))
			{
				decl String:team[10];
				team = GetClientTeam(client) > 1 ? "DEAD" : "SPEC";
				decl String:name[50];
				GetClientName(client, name, sizeof(name));
				if(GetConVarBool(g_CvarColors))
				{
					new Handle:hMessage = StartMessageAll("SayText2");
					BfWriteByte(hMessage, client);
					BfWriteByte(hMessage, true);
					BfWriteString(hMessage, "\x01*%s1* \x03%s2 \x04help!!!");
					BfWriteString(hMessage, team);
					BfWriteString(hMessage, name);
					EndMessage();
				} else {
					PrintToChatAll("*%s* %s help!!", team, name);
				}
			}
			g_helpCount[client]++;
		} else {
			PrintToChat(client, "%t", "dead cant help");
		}
	}
	
	return Plugin_Handled;
}
public Action:CommandFuck(client, args)
{
	if(!GetConVarBool(g_CvarEnabled))
	{
		return Plugin_Handled;
	}
	
	if(!client || !IsClientInGame(client))
	{
		return Plugin_Handled;
	}
	
	
	if(IsPlayerAlive(client))
	{
		if(g_fuckCount[client] >= GetConVarInt(g_CvarMaxfucks))
		{
			PrintToChat(client, "%t", "over fuck limit", GetConVarInt(g_CvarMaxfucks));
			return Plugin_Handled;
		}
		new Float:vec[3];
		GetClientEyePosition(client, vec);
		EmitAmbientSound(g_fuckList[GetRandomInt(0, 11)], vec, SOUND_FROM_WORLD, SNDLEVEL_SCREAMING, _, GetConVarFloat(g_CvarFuckVolume));
		if(GetConVarBool(g_CvarChat))
		{
			decl String:name[50];
			GetClientName(client, name, sizeof(name));
			if(GetConVarBool(g_CvarColors))
			{
				new Handle:hMessage = StartMessageAll("SayText2");
				BfWriteByte(hMessage, client);
				BfWriteByte(hMessage, true);
				BfWriteString(hMessage, "\x03%s1 \x04fuck!!!");
				BfWriteString(hMessage, name);
				EndMessage();
			} else {
				PrintToChatAll("%s fuck!!", name);
			}
		}
		g_fuckCount[client]++;
	} else {
		// the player is dead
		if(g_fuckCount[client] >= GetConVarInt(g_CvarMaxfucks))
		{
			PrintToChat(client, "%t", "over fuck limit", GetConVarInt(g_CvarMaxfucks));
			return Plugin_Handled;
		}
		if(GetConVarInt(g_CvarJeer) == 1 || (GetConVarInt(g_CvarJeer) == 2 && GetUserAdmin(client) != INVALID_ADMIN_ID))
		{
			for(new i = 1; i <= GetMaxClients(); i++)
			{
				if(IsClientInGame(i) && !IsFakeClient(i))
				{
					EmitSoundToClient(i, g_fuckList[GetRandomInt(0, 11)], _, _, _, _, GetConVarFloat(g_CvarFuckVolume));
				}
			}
			if(GetConVarBool(g_CvarChat))
			{
				decl String:team[10];
				team = GetClientTeam(client) > 1 ? "DEAD" : "SPEC";
				decl String:name[50];
				GetClientName(client, name, sizeof(name));
				if(GetConVarBool(g_CvarColors))
				{
					new Handle:hMessage = StartMessageAll("SayText2");
					BfWriteByte(hMessage, client);
					BfWriteByte(hMessage, true);
					BfWriteString(hMessage, "\x01*%s1* \x03%s2 \x04fuck!!!");
					BfWriteString(hMessage, team);
					BfWriteString(hMessage, name);
					EndMessage();
				} else {
					PrintToChatAll("*%s* %s fuck!!", team, name);
				}
			}
			g_fuckCount[client]++;
		} else {
			PrintToChat(client, "%t", "dead cant fuck");
		}
	}
	
	return Plugin_Handled;
}

public Action:CommandDawae(client, args)
{
	if(!GetConVarBool(g_CvarEnabled))
	{
		return Plugin_Handled;
	}
	
	if(!client || !IsClientInGame(client))
	{
		return Plugin_Handled;
	}
	
	
	if(IsPlayerAlive(client))
	{
		if(g_dawaeCount[client] >= GetConVarInt(g_CvarMaxdawaes))
		{
			PrintToChat(client, "%t", "over dawae limit", GetConVarInt(g_CvarMaxdawaes));
			return Plugin_Handled;
		}
		new Float:vec[3];
		GetClientEyePosition(client, vec);
		EmitAmbientSound(g_dawaeList[GetRandomInt(0, 11)], vec, SOUND_FROM_WORLD, SNDLEVEL_SCREAMING, _, GetConVarFloat(g_CvarDawaeVolume));
		if(GetConVarBool(g_CvarChat))
		{
			decl String:name[50];
			GetClientName(client, name, sizeof(name));
			if(GetConVarBool(g_CvarColors))
			{
				new Handle:hMessage = StartMessageAll("SayText2");
				BfWriteByte(hMessage, client);
				BfWriteByte(hMessage, true);
				BfWriteString(hMessage, "\x03%s1 \x04Da Wae!!!");
				BfWriteString(hMessage, name);
				EndMessage();
			} else {
				PrintToChatAll("%s Da Wae!!", name);
			}
		}
		g_dawaeCount[client]++;
	} else {
		// the player is dead
		if(g_dawaeCount[client] >= GetConVarInt(g_CvarMaxdawaes))
		{
			PrintToChat(client, "%t", "over dawae limit", GetConVarInt(g_CvarMaxdawaes));
			return Plugin_Handled;
		}
		if(GetConVarInt(g_CvarJeer) == 1 || (GetConVarInt(g_CvarJeer) == 2 && GetUserAdmin(client) != INVALID_ADMIN_ID))
		{
			for(new i = 1; i <= GetMaxClients(); i++)
			{
				if(IsClientInGame(i) && !IsFakeClient(i))
				{
					EmitSoundToClient(i, g_dawaeList[GetRandomInt(0, 11)], _, _, _, _, GetConVarFloat(g_CvarDawaeVolume));
				}
			}
			if(GetConVarBool(g_CvarChat))
			{
				decl String:team[10];
				team = GetClientTeam(client) > 1 ? "DEAD" : "SPEC";
				decl String:name[50];
				GetClientName(client, name, sizeof(name));
				if(GetConVarBool(g_CvarColors))
				{
					new Handle:hMessage = StartMessageAll("SayText2");
					BfWriteByte(hMessage, client);
					BfWriteByte(hMessage, true);
					BfWriteString(hMessage, "\x01*%s1* \x03%s2 \x04Da Wae!!!");
					BfWriteString(hMessage, team);
					BfWriteString(hMessage, name);
					EndMessage();
				} else {
					PrintToChatAll("*%s* %s Da Wae!!", team, name);
				}
			}
			g_dawaeCount[client]++;
		} else {
			PrintToChat(client, "%t", "dead cant dawae");
		}
	}
	
	return Plugin_Handled;
}

// Loads the soundsList array with the sounds
public LoadSounds()
{
	new Handle:kv = CreateKeyValues("BroadcastSoundsList");
	decl String:filename[PLATFORM_MAX_PATH];
	decl String:buffer[30];

	BuildPath(Path_SM, filename, PLATFORM_MAX_PATH, "configs/broadcastsoundslist.cfg");
	FileToKeyValues(kv, filename);
	
	if (!KvJumpToKey(kv, "cheer sounds"))
	{
		SetFailState("configs/broadcastsoundslist.cfg missing cheer sounds");
		CloseHandle(kv);
		return;
	}

	for(new i = 0; i < NUM_SOUNDS; i++)
	{
		Format(buffer, sizeof(buffer), "cheer sound %i", i + 1);
		KvGetString(kv, buffer, g_soundsList[i], PLATFORM_MAX_PATH);
	}	
	
	KvRewind(kv);
	if (!KvJumpToKey(kv, "jeer sounds"))
	{
		SetFailState("configs/broadcastsoundslist.cfg missing jeer sounds");
		CloseHandle(kv);
		return;
	}

	for(new i = 0; i < NUM_SOUNDS; i++)
	{
		Format(buffer, sizeof(buffer), "jeer sound %i", i + 1);
		KvGetString(kv, buffer, g_soundsListJeer[i], PLATFORM_MAX_PATH);
	}
	
	KvRewind(kv);
	if (!KvJumpToKey(kv, "help sounds"))
	{
		SetFailState("configs/broadcastsoundslist.cfg missing help sounds");
		CloseHandle(kv);
		return;
	}

	for(new i = 0; i < NUM_SOUNDS; i++)
	{
		Format(buffer, sizeof(buffer), "help sound %i", i + 1);
		KvGetString(kv, buffer, g_helpList[i], PLATFORM_MAX_PATH);
	}
	
	KvRewind(kv);
	if (!KvJumpToKey(kv, "fuck sounds"))
	{
		SetFailState("configs/broadcastsoundslist.cfg missing fuck sounds");
		CloseHandle(kv);
		return;
	}

	for(new i = 0; i < NUM_SOUNDS; i++)
	{
		Format(buffer, sizeof(buffer), "fuck sound %i", i + 1);
		KvGetString(kv, buffer, g_fuckList[i], PLATFORM_MAX_PATH);
	}
	
	KvRewind(kv);
	if (!KvJumpToKey(kv, "dawae sounds"))
	{
		SetFailState("configs/broadcastsoundslist.cfg missing dawae sounds");
		CloseHandle(kv);
		return;
	}

	for(new i = 0; i < NUM_SOUNDS; i++)
	{
		Format(buffer, sizeof(buffer), "dawae sound %i", i + 1);
		KvGetString(kv, buffer, g_dawaeList[i], PLATFORM_MAX_PATH);
	}
	
	KvRewind(kv);
	if (!KvJumpToKey(kv, "particles files"))
	{
		SetFailState("configs/broadcastsoundslist.cfg missing particles files");
		CloseHandle(kv);
		return;
	}

	for(new i = 0; i < NUM_SOUNDS; i++)
	{
		Format(buffer, sizeof(buffer), "particles file %i", i + 1);
		KvGetString(kv, buffer, g_particleList[i], PLATFORM_MAX_PATH);
	}	
	
	KvRewind(kv);
	if (!KvJumpToKey(kv, "custom files"))
	{
		SetFailState("configs/broadcastsoundslist.cfg missing custom files");
		CloseHandle(kv);
		return;
	}

	for(new i = 0; i < NUM_SOUNDS; i++)
	{
		Format(buffer, sizeof(buffer), "custom file %i", i + 1);
		KvGetString(kv, buffer, g_customList[i], PLATFORM_MAX_PATH);
	}	
	
	CloseHandle(kv);
}

// Initializations to be done at the beginning of the round
public EventRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	for(new i = 0; i <= MAXPLAYERS; i++)
	{
		g_cheerCount[i] = 0;
		g_jeerCount[i] = 0;
		g_helpCount[i] = 0;
		g_fuckCount[i] = 0;
		g_dawaeCount[i] = 0;
	}
}