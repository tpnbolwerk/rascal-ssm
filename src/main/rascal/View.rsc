module View

import Syntax;
import Compile;

import Content;
import IO;
import util::IDEServices;
import util::ShellExec;

str toDot(Machine m)=
    "digraph{<for (q <- m.states)
    {>
         '<for (t <- q.out) 
        {>
     '<q.name>-\><t.to> [ label=\"<t.event>\"];
        <}>
     <}>
    }";

str toSVG(Machine machine)
{
    writeFile(|project://Rascal/input.dot|, toDot(machine));
    str svg = exec("dot", workingDir=|project://Rascal/|, args = ["-Tsvg", "input.dot"]);
    return svg;
}

void view(Machine machine) {
    str svg = toSVG(machine);
    showInteractiveContent(content("callbackid", webServer(svg)));
}

Response (Request) webServer(str svg) {
    default Response reply(get(_)) {
        return response(pagina(svg));
    }
    return reply;
}

str pagina(str svg) 
    =   "\<html\>
        '   \<head\>
        '       \<style\>
        '           html, body, svg {
        '               width: 100%;
        '               height: 100%;
        '               margin: 0;
        '           }
        '       \</style\> 
        '   \</head\>
        '   \<body\>
        '       <svg>
        '   \<body\>
        '\<html\>";