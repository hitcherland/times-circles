import table.Table;

//@:uiComp("settings-view")
class SettingsView extends h2d.Flow implements h2d.domkit.Object {
    static var SRC = <settings-view>
        Settings
        <table id="table"></table>
    </settings-view>

    public function new(?settings:Array<Dynamic>, ?parent) {
        super(parent);
        initComponent();
        layout = h2d.Flow.FlowLayout.Vertical;
        verticalAlign = h2d.Flow.FlowAlign.Top;
        horizontalAlign = h2d.Flow.FlowAlign.Middle;

    }

    public function addTextSetting(?label:String, ?defaultValue:String, ?onChange:String->Void) {
        var font:h2d.Font = hxd.res.DefaultFont.get();

        var labelItem = new h2d.Text(font);
        labelItem.text = label+": ";
        labelItem.textAlign = Right;

        var inputItem = new h2d.TextInput(font);
        inputItem.text = defaultValue;
        inputItem.onChange = function() {
            onChange(inputItem.text);
        };

        var row = this.table.addRow([
            labelItem, inputItem
        ]);
    }
}

@:uiComp("setting-label")
class SettingLabelComp extends h2d.Flow implements h2d.domkit.Object {
    static var SRC = <setting-label>
        <flow><text text={label}/></flow>
    </setting-label> 

    public function new(?label:String="none", ?parent) {
        super(parent);
        fillWidth = true;
        initComponent();
    }
}

@:uiComp("text-setting")
class TextSettingComp extends h2d.Flow implements h2d.domkit.Object {
    static var SRC = <text-setting>
        <flow><input public id="input"/></flow>
    </text-setting> 

    public var callback:String->Void = function(text:String) {};

    public var value(get, set):String;
    public function get_value():String {
        return this.input.text;
    }
    public function set_value(v:String):String {
        return this.input.text = v;
    }

    public function new(?parent) {
        super(parent);
        layout = h2d.Flow.FlowLayout.Horizontal;
        verticalAlign = h2d.Flow.FlowAlign.Middle;
        horizontalAlign = h2d.Flow.FlowAlign.Middle;
        fillWidth = true;
        initComponent();

        this.input.onChange = this.onChange;
    }

    function onChange() {
        callback(this.value);
    }
}