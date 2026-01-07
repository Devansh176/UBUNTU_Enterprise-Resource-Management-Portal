<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tab 7: Puppeteer PDF Generation</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }

        .tab-container {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 20px;
            max-width: 500px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .tab-title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
    </style>
</head>
<body>

    <div class="tab-container">
        <div class="tab-title">
            Tab 7 : Puppeteer PDF Generation
        </div>

        <div id="tab7-container"></div>
    </div>

    <script type="text/javascript">
        var isTab7Loaded = false;

        window.initTab7 = function() {
            if (isTab7Loaded) return;
            isTab7Loaded = true;

            Ext.onReady(function() {
                Ext.create('Ext.panel.Panel', {
                    title: 'PDF Export Dashboard',
                    renderTo: 'tab7-container',
                    bodyPadding: 30,
                    width: '100%',
                    height: 250,

                    layout: {
                        type: 'vbox',
                        align: 'center',
                        pack: 'center'
                    },

                    items: [
                        {
                            xtype: 'button',
                            text: 'Generate PDF Report',
                            scale: 'large',
                            width: 250,

                            handler: function() {
                                var tVal = document.getElementById('s-title') ? document.getElementById('s-title').value : '';
                                var nVal = document.getElementById('s-name') ? document.getElementById('s-name').value : '';
                                var gVal = document.getElementById('s-gender') ? document.getElementById('s-gender').value : '';
                                var pVal = document.getElementById('s-prefix') ? document.getElementById('s-prefix').value : '';

                                var fromCmp = Ext.getCmp('tab4DateFrom');
                                var toCmp = Ext.getCmp('tab4DateTo');

                                var dFrom = '';
                                var dTo = '';

                                if(fromCmp && fromCmp.getValue()) {
                                    dFrom = Ext.Date.format(fromCmp.getValue(), 'Y-m-d');
                                }
                                if(toCmp && toCmp.getValue()) {
                                    dTo = Ext.Date.format(toCmp.getValue(), 'Y-m-d');
                                }

                                var url = 'downloadPuppeteerPdf?' +
                                    'title=' + encodeURIComponent(tVal) +
                                    '&name=' + encodeURIComponent(nVal) +
                                    '&dobFrom=' + encodeURIComponent(dFrom) +
                                    '&dobTo=' + encodeURIComponent(dTo) +
                                    '&gender=' + encodeURIComponent(gVal) +
                                    '&prefix=' + encodeURIComponent(pVal);

                                console.log("Downloading PDF with URL: " + url);

                                window.open(url, '_blank');
                            }
                        }
                    ]
                });
            });
        };

        // Auto-initialize on load
        Ext.onReady(function() {
            window.initTab7();
        });
    </script>

</body>
</html>