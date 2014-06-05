import QtQuick 2.0

Item {
    id: container
    property real hue: Math.random()
    anchors.fill: parent

    function normalize(x) {
        return Math.min(Math.max(x, 0), 1)
    }

    // Colorize the frame as necessary
    ShaderEffectSource {
        id: shaderSource
        sourceItem: container.parent
        smooth: true
    }

    ShaderEffect {
        id: shader
        anchors.fill: parent
        property variant source: shaderSource
        property color tint: {
            var h = 6 * hue;
            return Qt.rgba(normalize(Math.max(2 - h, h - 4)),
                           normalize(Math.min(h, 4 - h)),
                           normalize(Math.min(h - 2, 6 - h)))
        }
        fragmentShader: "" +
            "uniform sampler2D source;" +
            "uniform lowp vec4 tint;" +
            "uniform lowp float qt_Opacity;" +
            "varying highp vec2 qt_TexCoord0;" +
            "void main() {" +
            "    lowp vec4 c = texture2D(source, qt_TexCoord0);" +
            "    lowp float lo = min(min(c.x, c.y), c.z);" +
            "    lowp float hi = max(max(c.x, c.y), c.z);" +
            "    gl_FragColor = qt_Opacity * vec4(mix(vec3(lo), vec3(hi), tint.xyz), c.w);" +
            "}"
    }
}
