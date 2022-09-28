// --- Includes --- //
#include <a_samp>
#include <zcmd>
#include <a_http>
#include <foreach>

#pragma disablerecursion

// --- Defines --- //
#define SCM 	SendClientMessage
#define COLOR_WHITE 		0xFFFFFFFF
#define BLUE 				"{233EFA}"

// --- ChatBot Variables --- //
new CB_PEnabledChatBot[MAX_PLAYERS] = 0;
new CB_PChatBotActive[MAX_PLAYERS] = 0;
new CB_PChatBotUserMsg[MAX_PLAYERS][500];
new CB_PTDTime[MAX_PLAYERS] = 0;
//NEEDED VALUES
new api[20] = "api.brainshop.ai";
new bid = 164602; //API ID
new Bkey[20] = "usweDVoDWHhoWSDB"; //API KEY

new PlayerText:ChatBotTD[MAX_PLAYERS][4];
new PlayerLogged[MAX_PLAYERS];

// --- Main Function --- //
#define FUNCTION:%0(%1) \
	forward %0(%1);\
	public %0(%1)
	
// --- Public Functions --- //
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
 	print(" ----CHATBOT FILTERSCRIPT BY RJRYT---");
 	print(" -------- LOADED SUCCESFULLY --------");
  	print("--------------------------------------\n");
  	SetTimer("SecondTimer", 1000, true);
   	return 1;
}
public OnFilterScriptExit()
{
	print("\n--------------------------------------");
 	print(" ----CHATBOT FILTERSCRIPT BY RJRYT----");
 	print(" ------ UN-LOADED SUCCESFULLY --------");
  	print("--------------------------------------\n");
   	return 1;
}
public OnPlayerText(playerid, text[])
{
	if(PlayerLogged[playerid] == 1){
		if(CB_PEnabledChatBot[playerid] == 1) //Checking is chat bot is enabled
		{
	    	PostBotMessage(playerid, text);
	    	return 0;
		}
	}
	return 1;
}
public OnPlayerSpawn(playerid)
{
    PlayerLogged[playerid] = 1;
    ResetChatBotVar(playerid);
    return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
    PlayerLogged[playerid] = 0;
    ResetChatBotVar(playerid);
    return 1;
}
// --- ChatBot Control Command --- //
CMD:chatbot(playerid, params[])
{
	if(CB_PEnabledChatBot[playerid] == 1)
	{
 		SCM(playerid, COLOR_WHITE, ""BLUE"Chat Bot System is Stopped.");
   		CB_PEnabledChatBot[playerid] = 0;
     	return 1;
	} else {
 		SCM(playerid, COLOR_WHITE, ""BLUE"Chat Bot System is Loaded.");
   		SCM(playerid, COLOR_WHITE, "Type in chatbox to chat with bot.");
     	CB_PEnabledChatBot[playerid] = 1;
      	return 1;
	}
}
// --- Custom Functions --- //
stock RemoveSpace(arg[])
{
    new pos;
    if (strfind(arg, " ", true) != -1)
    {
        pos = strfind(arg, " ", true);
        strdel(arg, pos, pos+1);
        strins(arg, "+", pos, 240);
        RemoveSpace(arg);
    }
    else{
         return arg;
    }
    return arg;
}

FUNCTION:ResetChatBotVar(playerid)
{
    CB_PEnabledChatBot[playerid] = 0;
	CB_PChatBotActive[playerid] = 0;
	CB_PChatBotUserMsg[playerid] = "";
	CB_PTDTime[playerid] = 0;
	return 1;
}

FUNCTION:CreateChatBotTD(playerid)
{
	ChatBotTD[playerid][0] = CreatePlayerTextDraw(playerid, 164.000000, 129.000000, "_");
	PlayerTextDrawFont(playerid, ChatBotTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, ChatBotTD[playerid][0], 0.679166, 26.199981);
	PlayerTextDrawTextSize(playerid, ChatBotTD[playerid][0], 306.000000, 147.000000);
	PlayerTextDrawSetOutline(playerid, ChatBotTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, ChatBotTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, ChatBotTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, ChatBotTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, ChatBotTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, ChatBotTD[playerid][0], 74);
	PlayerTextDrawUseBox(playerid, ChatBotTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, ChatBotTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, ChatBotTD[playerid][0], 0);

	ChatBotTD[playerid][1] = CreatePlayerTextDraw(playerid, 162.000000, 132.000000, "New City Roleplay ChatBot");
	PlayerTextDrawFont(playerid, ChatBotTD[playerid][1], 0);
	PlayerTextDrawLetterSize(playerid, ChatBotTD[playerid][1], 0.366665, 1.350000);
	PlayerTextDrawTextSize(playerid, ChatBotTD[playerid][1], 427.000000, 183.000000);
	PlayerTextDrawSetOutline(playerid, ChatBotTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, ChatBotTD[playerid][1], 1);
	PlayerTextDrawAlignment(playerid, ChatBotTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, ChatBotTD[playerid][1], 16777215);
	PlayerTextDrawBackgroundColor(playerid, ChatBotTD[playerid][1], 35839);
	PlayerTextDrawBoxColor(playerid, ChatBotTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, ChatBotTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, ChatBotTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, ChatBotTD[playerid][1], 0);

	ChatBotTD[playerid][2] = CreatePlayerTextDraw(playerid, 94.000000, 161.000000, "text");
	PlayerTextDrawFont(playerid, ChatBotTD[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, ChatBotTD[playerid][2], 0.299997, 1.049998);
	PlayerTextDrawTextSize(playerid, ChatBotTD[playerid][2], 212.500000, 23.500000);
	PlayerTextDrawSetOutline(playerid, ChatBotTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, ChatBotTD[playerid][2], 1);
	PlayerTextDrawAlignment(playerid, ChatBotTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, ChatBotTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, ChatBotTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, ChatBotTD[playerid][2], 16711700);
	PlayerTextDrawUseBox(playerid, ChatBotTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, ChatBotTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, ChatBotTD[playerid][2], 0);

	ChatBotTD[playerid][3] = CreatePlayerTextDraw(playerid, 120.000000, 254.000000, "text");
	PlayerTextDrawFont(playerid, ChatBotTD[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, ChatBotTD[playerid][3], 0.295832, 1.049998);
	PlayerTextDrawTextSize(playerid, ChatBotTD[playerid][3], 236.000000, 93.500000);
	PlayerTextDrawSetOutline(playerid, ChatBotTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, ChatBotTD[playerid][3], 1);
	PlayerTextDrawAlignment(playerid, ChatBotTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, ChatBotTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, ChatBotTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, ChatBotTD[playerid][3], 16711700);
	PlayerTextDrawUseBox(playerid, ChatBotTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, ChatBotTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, ChatBotTD[playerid][3], 0);

	return 1;
}
FUNCTION:DestroyChatbotTD(playerid)
{
    PlayerTextDrawHide(playerid, ChatBotTD[playerid][0]);
	PlayerTextDrawHide(playerid, ChatBotTD[playerid][1]);
	PlayerTextDrawHide(playerid, ChatBotTD[playerid][2]);
	PlayerTextDrawHide(playerid, ChatBotTD[playerid][3]);

    PlayerTextDrawDestroy(playerid, ChatBotTD[playerid][0]);
	PlayerTextDrawDestroy(playerid, ChatBotTD[playerid][1]);
	PlayerTextDrawDestroy(playerid, ChatBotTD[playerid][2]);
	PlayerTextDrawDestroy(playerid, ChatBotTD[playerid][3]);
	CB_PChatBotActive[playerid] = 0;
	return 1;
}
FUNCTION:ShowChatBotTD(playerid, text[])
{
	if(CB_PChatBotActive[playerid] == 0){
	    CreateChatBotTD(playerid);
	    PlayerTextDrawShow(playerid, ChatBotTD[playerid][0]);
		PlayerTextDrawShow(playerid, ChatBotTD[playerid][1]);
		PlayerTextDrawShow(playerid, ChatBotTD[playerid][2]);
		PlayerTextDrawShow(playerid, ChatBotTD[playerid][3]);
		CB_PChatBotActive[playerid] = 1;
	}
	new str[500], str2[500];
	format(str, sizeof(str), "~y~%s~n~~n~~w~%s", GetRPName(playerid), CB_PChatBotUserMsg[playerid]);
	format(str2, sizeof(str2), "~y~ChatBot~n~~n~~w~%s", text);
 	PlayerTextDrawSetString(playerid, ChatBotTD[playerid][2], str);
 	PlayerTextDrawSetString(playerid, ChatBotTD[playerid][3], str2);
 	CB_PChatBotUserMsg[playerid] = "";
 	CB_PTDTime[playerid] = 20;
	return 1;
}
FUNCTION:PostBotMessage(playerid, msg[])
{
    strcat(CB_PChatBotUserMsg[playerid], msg, 500);
	new chatapi[500];
	RemoveSpace(msg);
	format(chatapi, sizeof(chatapi), "%s/get?bid=%d&key=%s&uid=%d&msg=%s",api, bid, Bkey, playerid, msg);
	HTTP(playerid, HTTP_GET, chatapi, "", "ChatApiRespond");
	return 1;
}
FUNCTION:ChatApiRespond(index, response_code, data[])
{
    if( response_code == 200 )
    {
        new
            start_pos = strfind( data, "{\"cnt\":\"" ) + 8,
            end_pos = strfind( data, "\"}", .pos = start_pos ),
            result[ 500 ];

        strmid( result, data,start_pos,end_pos );
        ShowChatBotTD(index, result);
    }
    else
    {
        ShowChatBotTD(index, "Somthing bad is happened, Check after some times.");
    }
}

FUNCTION:SecondTimer()
{
	foreach(new i : Player){
		if(PlayerLogged[i] == 1){
		    if(CB_PChatBotActive[i] == 1){
				if(CB_PTDTime[i] != 0){
				    CB_PTDTime[i]--;
				}else{
				    DestroyChatbotTD(i);
				}
		    }
    	}
	}
}

GetRPName(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));

	for(new i = 0, l = strlen(name); i < l; i ++)
	{
	    if(name[i] == '_')
	    {
	        name[i] = ' ';
		}
	}

	return name;
}
