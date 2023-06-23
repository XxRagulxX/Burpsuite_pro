#include "Resource.h"
#include <windows.h>

#define WIN32_LEAN_AND_MEAN

void BurpSuite(void)
{
	STARTUPINFO si = { 0 };
	PROCESS_INFORMATION pi = { 0 };
	si.cb = sizeof(si);
	si.wShowWindow = SW_HIDE;
	//TCHAR BurpSuite[] = TEXT("jre/bin/java -noverify -Dsun.java2d.uiScale.enabled=true --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED -javaagent:BurpSuiteLoader.jar -jar burpsuite_pro.jar");
	TCHAR BurpSuite[] = TEXT("jre/bin/javaw -noverify -Dsun.java2d.d3d=false -Dsun.java2d.noddraw=true --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED  -javaagent:BurpSuiteLoader.jar  -jar burpsuite_pro.jar");

	CreateProcess(NULL,
		BurpSuite,
		NULL,
		NULL,
		FALSE,
		DETACHED_PROCESS,
		NULL,
		NULL,
		&si,
		&pi);

	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);
	return;
}

int WINAPI WinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPreInstance, _In_ LPSTR lpCmdLine, _In_ int nShowCmd)
{
	BurpSuite();
	return 0;
}