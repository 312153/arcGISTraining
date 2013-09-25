<%--
  Created by IntelliJ IDEA.
  User: APshenicin
  Date: 25.09.13
  Time: 12:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Hello ArcGIS</title>
    <link rel="stylesheet" href="http://js.arcgis.com/3.6/js/dojo/dijit/themes/claro/claro.css">
    <link rel="stylesheet" href="http://js.arcgis.com/3.6/js/esri/css/esri.css">
    <style>
        html, body {
            width: 100%;
            height: 100%;
            margin: 0;
            overflow: hidden;
        }

        #borderContainerTwo {
            width: 100%;
            height: 100%;
        }
    </style>
    <!--<script>dojoConfig = {parseOnLoad: true};</script>-->
    <script src="http://js.arcgis.com/3.6/"></script>
</head>
<body class="claro">
<script type="text/javascript">
    var map, toolbar, symbol, geomTask;
    require(["dijit/layout/ContentPane",
        "dijit/layout/BorderContainer", "dijit/layout/TabContainer",
        "dijit/layout/AccordionContainer", "dijit/layout/AccordionPane", "dijit/Menu",
        "dijit/MenuItem", "dijit/MenuBar", "dijit/MenuBarItem",
        "dijit/PopupMenuBarItem"]);

    require(["esri/map",
        "esri/toolbars/draw",
        "esri/graphic",
        "esri/symbols/SimpleMarkerSymbol",
        "esri/symbols/SimpleLineSymbol",
        "esri/symbols/SimpleFillSymbol",
        "esri/dijit/BasemapGallery",
        "esri/arcgis/utils",
        "esri/dijit/OverviewMap",
        "esri/dijit/Scalebar",
        "dojo/parser",
        "dijit/registry",
        "dojo/query",
        "dojo/domReady!"], function (Map, Draw, Graphic, SimpleMarkerSymbol, SimpleLineSymbol, SimpleFillSymbol, BasemapGallery, arcgisUtils, OverviewMap, Scalebar, parser, registry, query) {

        parser.parse();
        map = new Map("map", {
            basemap: "topo",
            center: [-105.255, 40.022],
            zoom: 13,
            logo: false,
            nav: false,
            slider: true,
            sliderPosition: "top-left",
            sliderStyle: "large"
        });
        //add the basemap gallery, in this case we'll display maps from ArcGIS.com including bing maps
        var basemapGallery = new BasemapGallery({
            showArcGISBasemaps: true,
            map: map
        }, "basemapGallery");
        basemapGallery.startup();
        basemapGallery.on("error", function (msg) {
            console.log("basemap gallery error:  ", msg);
        });
        var overviewMapDijit = new OverviewMap({
            map: map,
            visible: true
        });
        overviewMapDijit.startup();
        var scalebar = new Scalebar({
            map: map,
            // "dual" displays both miles and kilmometers
            // "english" is the default, which displays miles
            // use "metric" for kilometers
            scalebarUnit: "metric"
        });
        var activateTool = function (drawButton) {
            var tool = drawButton.id.toUpperCase().replace(/ /g, "_");
            alert(tool);
            toolbar = new Draw(map);
        };
        query(".draw").on("click", function (evt) {
            var tool = this.id.toUpperCase().replace(/ /g, "_");
            map.hideZoomSlider();
            alert("Hello");
            toolbar = new Draw(map);
            toolbar.on("draw-end", function(evt){
                var symbol;
                toolbar.deactivate();
                map.showZoomSlider();

                switch (evt.geometry.type) {
                    case "point":
                    case "multipoint":
                        symbol = new SimpleMarkerSymbol();
                        break;
                    case "polyline":
                        symbol = new SimpleLineSymbol();
                        break;
                    default:
                        symbol = new SimpleFillSymbol();
                        break;
                }
                toolbar.activate(Draw[tool]);
                var graphic = new Graphic(evt.geometry, symbol);
                map.graphics.add(graphic);
            });
        });

    });
    require([
        "dojo/store/Memory",
        "dijit/tree/ObjectStoreModel",
        "dijit/Tree"], function (Memory, ObjectStoreModel, Tree) {

        // Create test store, adding the getChildren() method required by ObjectStoreModel
        var myStore = new Memory({
            data: [
                {id: 'world', name: 'The earth', type: 'planet', population: '6 billion'},
                {id: 'AF', name: 'Africa', type: 'continent', population: '900 million', area: '30,221,532 sq km',
                    timezone: '-1 UTC to +4 UTC', parent: 'world'},
                {id: 'EG', name: 'Egypt', type: 'country', parent: 'AF'},
                {id: 'KE', name: 'Kenya', type: 'country', parent: 'AF'},
                {id: 'Nairobi', name: 'Nairobi', type: 'city', parent: 'KE'},
                {id: 'Mombasa', name: 'Mombasa', type: 'city', parent: 'KE'},
                {id: 'SD', name: 'Sudan', type: 'country', parent: 'AF'},
                {id: 'Khartoum', name: 'Khartoum', type: 'city', parent: 'SD'},
                {id: 'AS', name: 'Asia', type: 'continent', parent: 'world'},
                {id: 'CN', name: 'China', type: 'country', parent: 'AS'},
                {id: 'IN', name: 'India', type: 'country', parent: 'AS'},
                {id: 'RU', name: 'Russia', type: 'country', parent: 'AS'},
                {id: 'MN', name: 'Mongolia', type: 'country', parent: 'AS'},
                {id: 'OC', name: 'Oceania', type: 'continent', population: '21 million', parent: 'world'},
                {id: 'EU', name: 'Europe', type: 'continent', parent: 'world'},
                {id: 'DE', name: 'Germany', type: 'country', parent: 'EU'},
                {id: 'FR', name: 'France', type: 'country', parent: 'EU'},
                {id: 'ES', name: 'Spain', type: 'country', parent: 'EU'},
                {id: 'IT', name: 'Italy', type: 'country', parent: 'EU'},
                {id: 'NA', name: 'North America', type: 'continent', parent: 'world'},
                {id: 'SA', name: 'South America', type: 'continent', parent: 'world'}
            ],
            getChildren: function (object) {
                return this.query({parent: object.id});
            }
        });
        // Create the model
        var myModel = new ObjectStoreModel({
            store: myStore,
            query: {id: 'world'}
        });
        // Create the Tree.
        var tree = new Tree({
            model: myModel
        }, "country");
        tree.startup();
    });</script>
<div data-dojo-type="dijit/layout/BorderContainer" data-dojo-props="gutters:true,
             liveSplitters:false" id="borderContainerTwo">
    <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'top', splitter:false">
        <div id="mainMenu" data-dojo-type="dijit/MenuBar">
            <div id="file" data-dojo-type="dijit/MenuBarItem">File</div>
            <div id="edit" data-dojo-type="dijit/MenuBarItem">Edit</div>
            <div id="view" data-dojo-type="dijit/MenuBarItem">View</div>
            <div id="draw" data-dojo-type="dijit/PopupMenuBarItem">
                <span>Draw</span>

                <div id="drawMenu" data-dojo-type="dijit/Menu">
                    <div id="point" data-dojo-type="dijit/MenuItem" class="draw"">
                        Point
                    </div>
                    <div id="multi_point" data-dojo-type="dijit/MenuItem" class="draw">
                        Multi Point
                    </div>
                    <div id="line" data-dojo-type="dijit/MenuItem" class="draw">
                        Line
                    </div>
                    <div id="polygon" data-dojo-type="dijit/MenuItem" class="draw">
                        Polygon
                    </div>
                </div>
            </div>
            <!-- end of sub-menu -->
        </div>
    </div>
    <div data-dojo-type="dijit/layout/AccordionContainer" data-dojo-props="minSize:20,
                 region:'leading', splitter:true" style="width: 300px;" id="leftAccordion">
        <div data-dojo-type="dijit/layout/AccordionPane" title="ArcGIS basemap" selected="true">
            <div id="basemapGallery"></div>
        </div>
        <div data-dojo-type="dijit/layout/AccordionPane" title="Another one">
            <div id="country"></div>
        </div>
        <div data-dojo-type="dijit/layout/AccordionPane" title="Even more fancy">
        </div>
        <div data-dojo-type="dijit/layout/AccordionPane" title="Last, but not least">
        </div>
    </div>
    <!-- end AccordionContainer -->
    <div data-dojo-type="dijit/layout/TabContainer" data-dojo-props="region:'center', tabStrip:true">
        <div data-dojo-type="dijit/layout/ContentPane" title="My first tab" selected="true">
            <div id="map" style="height: 100%;"></div>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" title="My second tab">

        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="closable:true" title="My last tab">
            Lorem ipsum and all around - last...
        </div>
    </div>
    <!-- end TabContainer -->
</div>
<!-- end BorderContainer -->
</body>
</html>