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
       return {
            <p.src, run (p.top, title="View FSM")>
        };
    }),
    
    executor(exec)
};



value exec(run(Machine p)) {
    try {
        view(p);
      
        return ("result": true);
    }
    catch loc src : {
        registerDiagnostics([error("Delen door nul is flauwekul", src)]);
        return ("result": false);
    }
}


int main(int testArgument = 0) {
    println("argument: <testArgument>");
    registerLanguage(prototype);
    return testArgument;
}