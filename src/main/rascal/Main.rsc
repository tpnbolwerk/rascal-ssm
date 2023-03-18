module Main

import Syntax;
import Analyze;
import Compile;
import View;

import IO;
import ParseTree;

import util::Reflective;
import util::IDEServices;
import util::LanguageServer;

import salix::demo::ide::IDE;

PathConfig pcfg = getProjectPathConfig(|project://Rascal|);
Language prototype = language(pcfg, "SM", "sm", "Main", "contribs");

data Command
    = run(Machine machine);

set[LanguageService] contribs() = {
    parser(start[Machine] (str program, loc src) {
        return parse(#start[Machine], program, src);
    }),

    lenses(rel[loc src, Command lens] (start[Machine] p) {
        // watch(|project:///Rascal|, false, f);
        // watch(p.src, true, watcher(changeEvent(p.src, modified(), file())));
        return {
            <p.src, run (p.top, title="View FSM")>
        };
    }),

    // summarizer(Summary (loc _, start[Machine] p) {
    //     return unreachable(p.top);
    // }),
    
    executor(exec)
};

// LocationChangeEvent watcher (LocationChangeEvent event){
    // println("change detected");
    // executor(exec);
// }

value exec(run(Machine p)) {
    try {
        // watch(|cwd:///|, false, f);
        // bekijken(vertaal(p));
        view(p);
      
        return ("result": true);
    }
    catch loc src : {
        // watch(src, false, f);
        // view(p);
        registerDiagnostics([error("Delen door nul is flauwekul", src)]);
        return ("result": false);
    }
}

void f(LocationChangeEvent e)
{
    println("test");
}

int main(int testArgument = 0) {
    println("argument: <testArgument>");
 
    // start[Machine] myStartMachine = parse(#start[Machine], |project:///example.sm|);
    // Machine myMachine = myStartMachine.top;
    // println(myMachine);
    // println(image(myMachine));
    // unreachableIds = unreachable(myMachine);
    // println(unreachableIds);
    // println(compile(myMachine));
    // println(graphviz(myMachine));
    registerLanguage(prototype);
    return testArgument;
}