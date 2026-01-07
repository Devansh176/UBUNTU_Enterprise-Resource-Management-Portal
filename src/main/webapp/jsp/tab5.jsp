<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tab 5: Excel Upload & Download</title>

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
            max-width: 800px;
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
            Tab 5 : Excel Operations (Upload / Download)
        </div>

        <div id="tab5-render-area"></div>
    </div>

    <script type="text/javascript">
        var isTab5Loaded = false;

        window.initTab5 = function() {
            if (isTab5Loaded) return;
            isTab5Loaded = true;

            Ext.onReady(function() {

                Ext.create('Ext.form.Panel', {
                    title: 'Excel Upload',
                    renderTo: 'tab5-render-area',
                    bodyPadding: 15,
                    width: 500,
                    height: 160,
                    defaults: {
                        anchor: '100%',
                        labelWidth: 100
                    },
                    items: [
                        {
                            xtype: 'filefield',
                            name: 'excelFile',
                            fieldLabel: 'Choose Excel',
                            labelSeparator: ':',
                            msgTarget: 'side',
                            allowBlank: false,
                            buttonText: 'Browse...'
                        }
                    ],
                    buttons: [
                        {
                            text: 'Upload File',
                            icon: 'https://cdn-icons-png.flaticon.com/16/724/724933.png',
                            handler: function() {
                                var form = this.up('form').getForm();
                                if (form.isValid()) {
                                    form.submit({
                                        url: 'uploadPatientExcel',
                                        waitMsg: 'Uploading your excel...',
                                        success: function(fp, o) {
                                            Ext.Msg.alert('Success', 'File Uploaded and Data Saved!');

                                            if (window.PatientManager && typeof window.PatientManager.search === 'function') {
                                                window.PatientManager.search();
                                            }
                                        },
                                        failure: function(fp, o) {
                                            Ext.Msg.alert('Error', 'File upload failed or server error.');
                                        }
                                    });
                                }
                            }
                        }
                    ]
                });

                Ext.create('Ext.panel.Panel', {
                    title: 'Excel Download',
                    renderTo: 'tab5-render-area',
                    bodyPadding: 15,
                    width: 500,
                    margin: '20 0 0 0',
                    items: [
                        {
                            xtype: 'container',
                            html: 'Click below to download the latest data report.',
                            style: 'margin-bottom: 10px; color: #555;'
                        },
                        {
                            xtype: 'button',
                            text: 'Download Data from DB',
                            scale: 'medium',
                            icon: 'https://cdn-icons-png.flaticon.com/16/724/724933.png',
                            handler: function() {
                                window.open('downloadPatientExcel', '_blank');
                            }
                        }
                    ]
                });
            });
        };

        // Auto-run on page load
        Ext.onReady(function() {
            window.initTab5();
        });
    </script>

</body>
</html>