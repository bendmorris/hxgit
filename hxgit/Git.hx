package hxgit;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.io.BytesOutput;
import haxe.io.Eof;
import sys.io.Process;


class Git
{
	macro static public function build(?repoPath:String):Array<Field>
	{
		if (repoPath == null) repoPath = Sys.getCwd();
		var process = new Process("git", ["-C", repoPath, "describe", "--always", "--tag"]);

		var buffer = new BytesOutput();

		var waiting = true;
		while (waiting)
		{
			try
			{
				var current = process.stdout.readAll(1024);
				buffer.write(current);

				if (current.length == 0)
					waiting = false;
			}
			catch (e:Eof)
			{
				waiting = false;
			}
		}

		process.close();
		var output = StringTools.trim(buffer.getBytes().toString());

		var fields:Array<Field> = Context.getBuildFields();

		fields.push({
			name: "git",
			doc: null,
			access: [AStatic, APublic],
			kind: FVar(macro : String, macro $v{output}),
			pos: Context.currentPos(),
		});

		return fields;
	}
}
