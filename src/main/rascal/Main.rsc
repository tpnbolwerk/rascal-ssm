module Main

import Syntax;
import Analyze;
import View;
import Check;

import IO;
import ParseTree;

import util::Reflective;
import util::IDEServices;
import util::LanguageServer;

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

    summarizer(Summary (loc _, start[Machine] p) {
        return check(p.top);}
    ),
    
    executor(exec)
};



value exec(run(Machine p)) {
    try {
        view(p);
        return ("result": true);
    }
    catch loc src : {
        registerDiagnostics([error("Something went wrong", src)]);
        return ("result": false);
    }
}


int main() {
    registerLanguage(prototype);
    return 0;
}