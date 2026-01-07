<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tab 2: Patient Details Popup</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f4f4f4;
        }

        .tab-container {
            padding: 20px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            max-width: 800px;
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

        .action-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .action-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="tab-container">
        <div class="tab-title">
            Tab 2 : Patient Details
        </div>

        <div>
            <p>Click the button below to open the Patient Details Editor.</p>
            <button class="action-btn" onclick="openEditorPopup()">
                Open Patient Details
            </button>
        </div>
    </div>
    <script type="text/javascript">
        Ext.onReady(function() {
            console.log("ExtJS is ready");
        });

        function openEditorPopup() {
            console.log("Attempting to open popup...");

            if (typeof Ext === 'undefined') {
                alert("ExtJS library not loaded!");
                return;
            }

            Ext.create('Ext.window.Window', {
                title: 'Patient Details',
                modal: true,
                width: 800,
                height: 550,
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                bodyPadding: 10,
                closeAction: 'destroy',

                items: [
                    {
                        xtype: 'container',
                        height: 200,
                        layout: 'hbox',
                        style: {
                            borderBottom: '1px solid #ccc',
                            marginBottom: '10px',
                            paddingBottom: '10px'
                        },
                        items: [
                            {
                                xtype: 'component',
                                flex: 1,
                                html: '<div style="line-height:1.8; font-family:Arial; font-size:12px;">' +
                                      '<b>Name</b> : Devansh<br>' +
                                      '<b>MRN</b> : 93874<br>' +
                                      '<b>Date Of Birth</b> : 17-06-2004<br>' +
                                      '<b>Age</b> : 21<br>' +
                                      '<b>Gender</b> : M<br>' +
                                      '<b>Address</b> : NGP<br>' +
                                      '<b>Reg Date</b> : 23-12-2025<br>' +
                                      '<b>Status</b> : Nice' +
                                      '</div>'
                            },
                            {
                                xtype: 'component',
                                flex: 1,
                                html: '<div style="line-height:1.8; font-family:Arial; font-size:12px;">' +
                                    '<div style="font-size:15px; font-weight:bold; margin-bottom:5px;">Test done:</div>'+
                                    'CT SCAN<br>' +
                                    'CYTOLOGY<br>' +
                                    'DIGITAL X-RAY<br>' +
                                    'FLUID EXAMINATION<br>' +
                                    'GASTROENTEROLOGY INVESTIGATION<br>' +
                                    'HAEMATOLOGY<br>' +
                                    'HORMONES<br>' +
                                    'HISTOPATHOLOGY' +
                                    '</div>'
                            }
                        ]
                    },

                    {
                        xtype: 'component',
                        html: '<b>Text Editor</b>',
                        margin: '0 0 5 0'
                    },

                    {
                        xtype: 'htmleditor',
                        flex: 1,
                        enableColors: true,
                        enableAlignments: true,
                        value: 'CT SCAN, CYTOLOGY, DIGITAL X-RAY, FLUID EXAMINATION, GASTROENTEROLOGY INVESTIGATION'
                    }
                ],

                buttons: [{
                    text: 'Close',
                    handler: function(btn) {
                        btn.up('window').close();
                    }
                }]
            }).show();
        }
    </script>
</body>
</html>