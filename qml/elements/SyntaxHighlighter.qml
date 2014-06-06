import QtQuick 2.0

Rectangle {
    id: container
    property string text
    clip: true
    color: "#22282a"

    Text {
        anchors.fill: parent
        text: highlightText(container.text)
        font.pointSize: 6
        color: "#f1f2f3"
        function highlightText(t) {
            var patterns = {
                // General
                'comment': /\/\*[\s\S]*?\*\/|(\/\/)[\s\S]*?$/gm,
                'constant': /\b(\d+(\.\d+)?(e(\+|\-)?\d+)?(f|d)?|0x[\da-f]+|true|false|null)\b/gi,
                'keyword': /\b(and|array|as|b(ool(ean)?|reak)|c(ase|atch|har|lass|on(st|tinue))|d(ef|elete|o(uble)?)|e(cho|lse(if)?|xit|xtends|xcept)|f(inally|loat|or(each)?|unction)|global|if|import|int(eger)?|long|new|object|or|pr(int|ivate|otected)|public|return|self|st(ring|ruct|atic)|switch|th(en|is|row)|try|(un)?signed|var|void|while)(?=\(|\b)/gi,
                'function': /(function)\s(.*?)(?=\()/g,
                'support': /\b(window|document)\b|\.(length|node(Name|Value)|getAttribute|push|getElementById|getElementsByClassName|log|setTimeout|setInterval)\b/g,
                'storage': /(var)?(\s|^)(\S*)(?=\s?=\s?function\()/g,
            }

            var colors = {
                'comment': "#66747B",
                'constant': "#EC7600",
                'keyword': "#93C763",
                'support': "#FACD22",
                'function': "#CDFA22",
                'string': "#22CDFA",
            }

            // Do string matches first
            t = t.replace(/\".*\"|\'\.*\'/g, '<font color="' + colors["string"] + '">$&</font>')

            // Then iterate over the patterns and match them all
            for (var p in patterns) {
                t = t.replace(patterns[p], '<font color="' + colors[p] + '">$&</font>')
            }
            return "<pre>" + t + "</pre>";
        }
    }
}