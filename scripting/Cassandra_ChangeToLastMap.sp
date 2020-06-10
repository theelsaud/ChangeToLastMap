#define AUTOLOAD_EXTENSIONS
#define REQUIRE_EXTENSIONS
#include <Cassandra>

#define FILE_PATH 		"data/crash_lastmap.txt"

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

	if(FileExists(sPath))
	{
		DeleteFile(sPath);
	}

	GetCurrentMap(g_szMap, sizeof(g_szMap));

	Handle hFile = OpenFile(sPath, "a");
	WriteFileLine(hFile, g_szMap);

	CloseHandle(hFile);
}

public void OnMapStart()
{
	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof sPath, FILE_PATH);

	if(FileExists(sPath))
	{
		Handle hFile = OpenFile(sPath,"r");
		ReadFileLine(hFile, g_szMap, sizeof(g_szMap));
		CloseHandle(hFile);
		DeleteFile(sPath);

		LogMessage("[Cassandra] Create timer after...");
		CreateTimer(5.0, ftimer, _);
	}
}

Action ftimer(Handle hTimer, any data)
{
	LogMessage("[Cassandra] Change map after crash: %s", g_szMap);
	ForceChangeLevel(g_szMap, "Server Crash");
}