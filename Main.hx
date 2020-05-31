import h2d.Scene;
import ControlValues;

typedef Point = {
    var x:Float;
    var y:Float;
}

class FadeCircle extends h3d.shader.ScreenShader {
    static var SRC = {
        @param var texture : Sampler2D;
        @param var radius: Float;
        @param var size: {width:Int, height:Int};
        
        function fragment() {
            pixelColor = texture.get(input.uv);
            var x = input.position.x * size.width;
            var y = input.position.y * size.height;
            var r = sqrt(x * x + y * y);
            if(r > radius) {
                var v = 1 - (r - radius) / (1.2 - radius);
                pixelColor.r *= v;
                pixelColor.g *= v;
                pixelColor.b *= v;
            }
        }
    }
}

class Main extends hxd.App {
    var radius:Float = 0.4;
    var velocity:Float = 1;
    var settingsView:SettingsView;
    var table:ModuloTable;
    var multiplierView:Dynamic;

    #if debug
    var fps:h2d.Text;
    #end

    override function onResize() {
        super.onResize();
        table.radius = Math.floor(radius * Math.min(s2d.width, s2d.height));
        table.x = s2d.width / 2;
        table.y = s2d.height / 2;
    }

    override function init() {
        super.init();      
        #if debug
        var font : h2d.Font = hxd.res.DefaultFont.get();
        fps = new h2d.Text(font, s2d);
        fps.text = "0.0";
        #end

        table = new ModuloTable(s2d);

        settingsView = new SettingsView(s2d);
        settingsView.minHeight = s2d.height;
        settingsView.maxHeight = s2d.height;

        settingsView.minWidth = 100;
        settingsView.maxWidth = Math.floor(s2d.width * 0.2);


        settingsView.addTextSetting("radius [0:1]", '${radius}', function (text:String) {
            var value = Std.parseFloat(text);
            if(hxd.Math.isNaN(value)) {
               return;
            }
            radius = value;
            onResize();
        });

        settingsView.addTextSetting("count [0:]", '${table.count}', function (text:String) {
            var value = Std.parseInt(text);
            if(hxd.Math.isNaN(value)) {
               return;
            }
            table.count = value;
        });

        settingsView.addTextSetting("speed", '${velocity}', function (text:String) {
            var value = Std.parseFloat(text);
            if(hxd.Math.isNaN(value)) {
               return;
            }
            velocity = value;
        });

        settingsView.addTextSetting("line opacity", '${table.lineOpacity}', function (text:String) {
            var value = Std.parseFloat(text);
            if(hxd.Math.isNaN(value)) {
               return;
            }
            table.lineOpacity = value;
        });

        settingsView.addTextSetting("line thickness", '${table.lineThickness}', function (text:String) {
            var value = Std.parseFloat(text);
            if(hxd.Math.isNaN(value)) {
               return;
            }
            table.lineThickness = value;
        });

        settingsView.reflow();

        var style = new h2d.domkit.Style();
        style.load(hxd.Res.css.settings); 
        style.addObject(settingsView);

        onResize();
    }

    override function update(dt:Float) {
        //adjustables.update(dt);
        if(velocity != 0) {
            table.multiplier += velocity * dt;
        }
        
        #if debug
        fps.text = '${hxd.Math.round(1 / dt)}fps';
        #end
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}