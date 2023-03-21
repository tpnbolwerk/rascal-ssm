module Check

import View;
import Analyze;

import util::LanguageServer;
import Syntax;

Summary check(Machine p) {
    view(p);
    return summary(p.src,
        messages = {},
        definitions = {}
    );
}