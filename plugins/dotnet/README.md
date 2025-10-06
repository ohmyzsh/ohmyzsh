# .NET Core CLI plugin

This plugin provides completion and useful aliases for [.NET Core CLI](https://dotnet.microsoft.com/).

To use it, add `dotnet` to the plugins array in your zshrc file.

```
plugins=(... dotnet)
```

## Aliases

| Alias | Command          | Description                                                       |
|-------|------------------|-------------------------------------------------------------------|
| dn    | dotnet new       | Create a new .NET project or file.                                |
| dr    | dotnet run       | Build and run a .NET project output.                              |
| dt    | dotnet test      | Run unit tests using the test runner specified in a .NET project. |
| dw    | dotnet watch     | Watch for source file changes and restart the dotnet command.     |
| dwr   | dotnet watch run | Watch for source file changes and restart the `run` command.      |
| dwt   | dotnet watch test| Watch for source file changes and restart the `test` command.     |
| ds    | dotnet sln       | Modify Visual Studio solution files.                              |
| da    | dotnet add       | Add a package or reference to a .NET project.                     |
| dp    | dotnet pack      | Create a NuGet package.                                           |
| dng   | dotnet nuget     | Provides additional NuGet commands.                               |
| db    | dotnet build     | Build a .NET project                                              |
| dres  | dotnet restore   | Restore dependencies and project-specific tools for a project.    |