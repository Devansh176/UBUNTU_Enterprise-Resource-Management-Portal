<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tab 6: Web Service </title>
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
            max-width: 1250px;
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
            Tab 6 : Web Service
        </div>

        <div id="tab6-render-area"></div>
    </div>

    <script type="text/javascript">
        var isTab6Loaded = false;

        window.initTab6 = function() {
            if (isTab6Loaded) return;
            isTab6Loaded = true;

            Ext.onReady(function() {

                var createPanel = Ext.create('Ext.form.Panel', {
                    title: '1. Create New Record',
                    bodyPadding: 15,
                    margin: '0 0 20 0',
                    frame: true,
                    layout: 'column',

                    defaults: {
                        labelAlign: 'top',
                        margin: '0 20 10 0',
                        columnWidth: 0.3
                    },

                    items: [
                        {
                            xtype: 'combo',
                            name: 'title',
                            fieldLabel: 'Title',
                            store: ['MR', 'MRS', 'MS', 'DR', 'PROF'],
                            emptyText: 'Select...',
                            editable: false
                        },
                        {
                            xtype: 'textfield',
                            name: 'name',
                            fieldLabel: 'Full Name',
                            emptyText: 'Enter Name',
                            columnWidth: 0.4,
                            allowBlank: false
                        },
                        {
                            xtype: 'datefield',
                            name: 'dob',
                            fieldLabel: 'Date of Birth',
                            format: 'Y-m-d',
                            maxValue: new Date(),
                            allowBlank: false
                        },
                        {
                            xtype: 'combo',
                            name: 'gender',
                            fieldLabel: 'Gender',
                            store: ['MALE', 'FEMALE', 'OTHER'],
                            emptyText: 'Select...',
                            editable: false
                        },
                        {
                            xtype: 'combo',
                            name: 'prefix',
                            fieldLabel: 'Prefix',
                            store: ['SO', 'HO', 'FO', 'DO', 'WO', 'MO'],
                            emptyText: 'Select...',
                            editable: false
                        },
                        {
                            xtype: 'container',
                            columnWidth: 0.3,
                            layout: { type: 'vbox', align: 'start', pack: 'end' },
                            items: [
                                { xtype: 'component', height: 23 },
                                {
                                    xtype: 'button',
                                    text: 'Create Record',
                                    scale: 'medium',
                                    width: 150,
                                    icon: 'https://cdn-icons-png.flaticon.com/16/992/992651.png',
                                    handler: function() {
                                        var form = this.up('form').getForm();
                                        if (form.isValid()) {
                                            var values = form.getValues();
                                            // Format Date manually to ensure YYYY-MM-DD
                                            var rawDob = form.findField('dob').getValue();
                                            if(rawDob) {
                                                values.dob = Ext.Date.format(rawDob, 'Y-m-d');
                                            }

                                            Ext.Ajax.request({
                                                url: 'api/patient',
                                                method: 'POST',
                                                params: values,
                                                success: function(response) {
                                                    Ext.Msg.alert('Success', 'Record created successfully!');
                                                    if (window.PatientManager && typeof window.PatientManager.search === 'function') {
                                                        window.PatientManager.search();
                                                    }
                                                    form.reset();
                                                },
                                                failure: function(response) {
                                                    Ext.Msg.alert('Error', 'Failed to create record. Server Error.');
                                                }
                                            });
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                });

                var deletePanel = Ext.create('Ext.form.Panel', {
                    title: '2. Delete Record',
                    bodyPadding: 15,
                    margin: '0 0 20 0',
                    frame: true,
                    layout: 'hbox',
                    items: [
                        {
                            xtype: 'numberfield',
                            name: 'id',
                            fieldLabel: 'ID to Delete',
                            labelWidth: 80,
                            width: 250,
                            emptyText: 'Enter ID',
                            margin: '0 15 0 0',
                            minValue: 1
                        },
                        {
                            xtype: 'button',
                            text: 'Delete Record',
                            icon: 'https://cdn-icons-png.flaticon.com/16/1214/1214428.png',
                            handler: function() {
                                var idField = this.up('form').down('numberfield');
                                var id = idField.getValue();
                                if (!id) {
                                    Ext.Msg.alert('Error', 'Please enter a valid ID');
                                    return;
                                }

                                Ext.Msg.confirm('Confirm', 'Are you sure you want to delete ID: ' + id + '?', function(btn){
                                    if(btn === 'yes'){
                                        Ext.Ajax.request({
                                            url: 'api/patient/' + id,
                                            method: 'DELETE',
                                            success: function(response) {
                                                Ext.Msg.alert('Success', 'Record deleted.');
                                                if (window.PatientManager && typeof window.PatientManager.search === 'function') {
                                                    window.PatientManager.search();
                                                }
                                                idField.reset();
                                            },
                                            failure: function(response) {
                                                Ext.Msg.alert('Error', 'Delete failed. ID may not exist.');
                                            }
                                        });
                                    }
                                });
                            }
                        }
                    ]
                });

                var listPanel = Ext.create('Ext.panel.Panel', {
                    title: '3. List All Records (JSON)',
                    bodyPadding: 15,
                    frame: true,
                    layout: 'anchor',
                    items: [
                        {
                            xtype: 'button',
                            id: 'btn-refresh-list',
                            text: 'Refresh JSON List',
                            icon: 'https://cdn-icons-png.flaticon.com/16/2805/2805358.png',
                            margin: '0 0 10 0',
                            handler: function() {
                                var area = Ext.getCmp('jsonOutput');
                                area.setValue('Loading...');

                                Ext.Ajax.request({
                                    url: window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) + '/api/patients',                                    method: 'GET',
                                    success: function(response) {
                                        var text = response.responseText;
                                        try {
                                            var json = JSON.parse(text);
                                            area.setValue(JSON.stringify(json, null, 4));
                                        } catch(e) {
                                            area.setValue(text);
                                        }
                                    },
                                    failure: function(response) {
                                        area.setValue('Error: ' + response.status + ' ' + response.statusText);
                                    }
                                });
                            }
                        },
                        {
                            xtype: 'textareafield',
                            id: 'jsonOutput',
                            anchor: '100%',
                            height: 300,
                            readOnly: true,
                            fieldStyle: 'background-color: #222; color: #0f0; font-family: monospace; border: 1px solid #ccc; padding: 10px;',
                            value: '// Click "Refresh" to fetch data from database...'
                        }
                    ]
                });

                // Combine all panels into the main container //
                Ext.create('Ext.container.Container', {
                    renderTo: 'tab6-render-area',
                    width: '100%',
                    items: [createPanel, deletePanel, listPanel]
                });
            });
        };

        // Initialize immediately on page load
        Ext.onReady(function() {
            window.initTab6();
        });
    </script>
</body>
</html>