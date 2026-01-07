<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tab 8: Dynamic Cron Job Manager</title>
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
            max-width: 900px;
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
            Tab 8 : Dynamic Cron Job Manager
        </div>

        <div id="tab8-container"></div>
    </div>

    <script type="text/javascript">
        var isTab8Loaded = false;

        window.initTab8 = function() {
            if(isTab8Loaded) return;
            isTab8Loaded = true;

            Ext.onReady(function() {
                var logStore = Ext.create('Ext.data.Store', {
                    fields: ['logEntry'],
                    proxy: {
                        type: 'ajax',
                        url: 'api/cron/logs',
                        reader: {
                            type: 'json'
                        }
                    },
                    autoLoad: true
                });

                // 2. Polling Task (Refreshes data every 2 seconds)
                var pollTask = {
                    run: function() {
                        if (Ext.getCmp('tab8CronLogs')) {
                            logStore.reload();
                            refreshStatus();
                        } else {
                            Ext.TaskManager.stop(this);
                        }
                    },
                    interval: 5000
                };
                Ext.TaskManager.start(pollTask);


                var refreshStatus = function() {
                    Ext.Ajax.request({
                        url: 'api/cron/current',
                        method: 'GET',
                        success: function(response) {
                            var currentCron = response.responseText;
                            var lbl = Ext.getCmp('currentCronDisplay');
                            if(lbl) {
                                lbl.update(
                                    '<div style="background:#e3f2fd; padding:10px; border-radius:5px; border:1px solid #90caf9; color:#1565c0; font-family:Arial;">' +
                                    '<b>Current Schedule:</b> ' + currentCron +
                                    '</div>'
                                );
                            }
                        }
                    });
                };


                Ext.create('Ext.panel.Panel', {
                    title: 'Dynamic Cron Job Manager',
                    renderTo: 'tab8-container',
                    width: '100%',
                    height: 600,
                    layout: { type: 'vbox', align: 'stretch' },
                    bodyPadding: 15,

                    items: [
                        {
                            xtype: 'fieldset',
                            title: 'Scheduler Configuration',
                            collapsible: false,
                            padding: 15,
                            defaults: { labelWidth: 120 },
                            items: [
                                {
                                    xtype: 'component',
                                    id: 'currentCronDisplay',
                                    margin: '0 0 15 0',
                                    html: 'Loading status...'
                                },
                                {
                                    xtype: 'container',
                                    layout: 'hbox',
                                    items: [
                                        {
                                            xtype: 'textfield',
                                            id: 'cronInput',
                                            emptyText: 'e.g. */5 * * * * *',
                                            width: 300,
                                            height: 32
                                        },
                                        {
                                            xtype: 'button',
                                            text: 'Update Schedule',
                                            icon: 'https://cdn-icons-png.flaticon.com/16/2099/2099058.png',
                                            scale: 'medium',
                                            margin: '0 0 0 10',
                                            handler: function() {
                                                var expr = Ext.getCmp('cronInput').getValue();
                                                if(!expr) {
                                                    Ext.Msg.alert('Warning', 'Please enter a valid cron expression');
                                                    return;
                                                }

                                                Ext.Ajax.request({
                                                    url: 'api/cron/update',
                                                    method: 'POST',
                                                    params: { expression: expr },
                                                    success: function(response) {
                                                        Ext.Msg.alert('Success', response.responseText);
                                                        logStore.reload();
                                                        refreshStatus();
                                                    },
                                                    failure: function() {
                                                        Ext.Msg.alert('Error', 'Server connection failed');
                                                    }
                                                });
                                            }
                                        }
                                    ]
                                }
                            ]
                        },


                        {
                            xtype: 'grid',
                            id: 'tab8CronLogs',
                            title: 'Live Execution Monitor',
                            store: logStore,
                            flex: 1,
                            margin: '15 0 0 0',
                            columns: [
                                {
                                    text: 'Status Log',
                                    dataIndex: 'logEntry',
                                    flex: 1,
                                    renderer: function(value) {
                                        if(value.includes("Error")) return '<span style="color:#d32f2f; font-weight:bold;">&#10006; ' + value + '</span>';
                                        if(value.includes("Configuration")) return '<span style="color:#1976d2; font-weight:bold;">&#8505; ' + value + '</span>';
                                        if(value.includes("CRON")) return '<span style="color:#388e3c;">&#10004; ' + value + '</span>';
                                        return value;
                                    }
                                }
                            ],
                            viewConfig: {
                                stripeRows: true,
                                emptyText: '<div style="text-align:center; padding:20px; color:#aaa;">No logs generated yet</div>',
                                deferEmptyText: false
                            },
                            tools: [{
                                type: 'refresh',
                                tooltip: 'Force Refresh',
                                handler: function() { logStore.reload(); }
                            }]
                        }
                    ]
                });
            });
        };

        // Initialize immediately
        Ext.onReady(function() {
            window.initTab8();
        });
    </script>

</body>
</html>