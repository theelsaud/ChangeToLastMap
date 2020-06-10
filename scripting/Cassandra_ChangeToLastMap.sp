#define AUTOLOAD_EXTENSIONS
#define REQUIRE_EXTENSIONS
#include <Cassandra>

#define FILE_PATH 		"data/crash_lastmap.txt"

#define METHOD_CHANGE 1

static char g_szMap[256];

public Plugin myinfo =
{
	name = "[Cassandra] Change To Last Map",
	author = "FIVE",
	version = "1.0.0",
	url = "http://hlmod.ru"
};

public void OnServerCrash()
{
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof sPath, FILE_PATH);

	GetCurrentMap(g_szMap, sizeof(g_szMap));

	Handle hFile = OpenFile(sPath, "w");
	WriteFileLine(hFile, g_szMap);

	CloseHandle(hFile);
}

#if METHOD_CHANGE == 1
public void OnClientPutInServer(int iClient)
{
	static bool bFirst;
	if(bFirst || IsFakeClient(iClient)) return;

	ChangeToLastMap();

	bFirst = true;
}
#else
public void OnMapStart()
{
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof sPath, FILE_PATH);
	
	if(FileExists(sPath))
	{
		CreateTimer(5.0, fTimer);
	}
}

Action fTimer(Handle hTimer, any data)
{
	ChangeToLastMap();
}
#endif

void ChangeToLastMap()
{
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof sPath, FILE_PATH);

	if(FileExists(sPath))
	{
		Handle hFile = OpenFile(sPath,"r");
		ReadFileLine(hFile, g_szMap, sizeof(g_szMap));
		CloseHandle(hFile);
		DeleteFile(sPath);

		LogMessage("Change map after crash: %s", g_szMap);
		ForceChangeLevel(g_szMap, "Server Crash");
	}
}