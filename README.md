Usage:

    @:build(hxgit.Git.build("/path/to/my/repo"))
    class Something {}

A macro will insert a static String field "git" to that class, containing the 
output of git describe for the given repo.