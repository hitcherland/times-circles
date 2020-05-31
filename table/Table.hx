package table;
using Lambda;

@:uiComp("table")
class TableComp extends h2d.Flow implements h2d.domkit.Object {
    static var SRC = <table></table>
    public var rows:Array<TrComp> = [];

    public function new(?parent) {
        super(parent);
        initComponent();
        layout = h2d.Flow.FlowLayout.Vertical;

        onBeforeReflow = function() {
            var maxWidths:Array<Int> = [];
            var maxHeights:Array<Int> = [];

            for(row in rows) {
                var maxH = 0;
                for(i in 0...row.cells.length) {
                    var cell = row.cells[i];
                    var w = cell.outerWidth;
                    var h = cell.outerHeight;

                    if(i >= maxWidths.length) {
                        maxWidths.push(w);
                    } else if(maxWidths[i] < w) {
                        maxWidths[i] = w;
                    }

                    if(h > maxH) {
                        maxH = h;
                    }
                }
                maxHeights.push(maxH);
            }

            for(row in rows) {
                for(i in 0...row.cells.length) {
                    row.cells[i].minWidth = maxWidths[i];
                    row.cells[i].minHeight = maxHeights[i];
                }
            }
        }
    }

    public function addRow(?contents:Array<Dynamic>):TrComp {
        var row = new TrComp(this);
        rows.push(row);
        if(contents != null) {
            for(content in contents) {
                row.addCell(content);
            }
        }
        return row;
    }
}

@:uiComp("tr")
class TrComp extends h2d.Flow implements h2d.domkit.Object {
    static var SRC = <tr></tr>
    public var cells:Array<TdComp> = [];
    public function new(?parent) {
        super(parent);
        initComponent();
        verticalAlign = Top;
    }

    public function addCell(?content) {
        trace("addCell");
        var cell = new TdComp(this);
        cells.push(cell);
        if(content != null) {
            cell.addChild(content);
        }
        return cell;
    }

    public function getMaxWidth(index:Int) {
        var widths = cells.map(function (c) {
            return c.outerWidth;
        });
        
        var max = widths.fold(Math.max, widths[0]);
        return max;
    }

    public function getMaxHeight(index:Int) {
        var heights = cells.map(function (c) {
            return c.outerHeight;
        });
        
        var max = heights.fold(Math.max, heights[0]);
        return max;
    }
}

@:uiComp("td")
class TdComp extends h2d.Flow implements h2d.domkit.Object {
    static var SRC = <td></td>

    public function new(?parent) {
        super(parent);
        initComponent();

        verticalAlign = Middle;
    }
}