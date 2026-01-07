<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tab 3: Staff List Grid</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }

        #grid-container {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

    <div id="grid-container"></div>

    <script type="text/javascript">
        var isTab3Loaded = false;

        window.initTab3 = function() {
            if(isTab3Loaded) return;
            isTab3Loaded = true;

            Ext.onReady(function() {
                Ext.define('StaffModel', {
                    extend: 'Ext.data.Model',
                    fields: ['name', 'code', 'userType', 'phone', 'department', 'status', 'joiningDate']
                });

                var dataStore = Ext.create('Ext.data.Store', {
                    model: 'StaffModel',
                    pageSize: 10,
                    data: [
                        { name: "Dr. JOHN DOE", code: "DROIJHGT5", userType: "Doctor", phone: "0000000000", department: "NEUROLOGY", status: "Confirmed", joiningDate: "01-01-2022" },
                        { name: "Dr. ROHIT S", code: "DRQWSDFG3", userType: "Doctor", phone: "2345678901", department: "RADIATION ONCOLOGY", status: "Confirmed", joiningDate: "19-01-2022" },
                        { name: "Mr. VIRAT K", code: "MREWF80D", userType: "Staff", phone: "0987654321", department: "OUTSOURCE MAINTENANCE", status: "Trainee", joiningDate: "28-02-2018" },
                        { name: "Dr. ABHISHEK SHAH", code: "DR32EW8RF", userType: "Doctor", phone: "222222567", department: "ULTRASOUND", status: "Confirmed", joiningDate: "01-01-2022" },
                        { name: "Dr. ABHISHEK KUMAR", code: "DRBYU0WRF", userType: "Consultant", phone: "9960880354", department: "SURGICAL ONCOLOGY", status: "Confirmed", joiningDate: "11-03-2012" },
                        { name: "Ms. SHRADDHA K", code: "MS82YWSC", userType: "Consultant", phone: "1234123412", department: "NURSING", status: "Regular", joiningDate: "23-09-2023" },
                        { name: "Mrs. RAJEEV GUPTA", code: "MRS82YWSC", userType: "Consultant", phone: "4321432133", department: "NURSING", status: "Regular", joiningDate: "12-09-2023" },
                        { name: "Ms. ABIGAIL GUPTA", code: "MS82YWSC", userType: "Consultant", phone: "5678567855", department: "NURSING", status: "Regular", joiningDate: "31-10-2023" },
                        { name: "Mr. PRITAM LAL", code: "MRBVFR12", userType: "Staff", phone: "9876123454", department: "INSURANCE", status: "Confirmed", joiningDate: "05-06-2022" },
                        { name: "Mr. PK BOSE", code: "MR129WIEU", userType: "Staff", phone: "2112355442", department: "PHYSIOTHERAPY", status: "Confirmed", joiningDate: "15-07-2021" }
                    ],
                    proxy: {
                        type: 'memory',
                        enablePaging: true,
                        reader: {
                            type: 'json'
                        }
                    }
                });

                Ext.create('Ext.grid.Panel', {
                    renderTo: 'grid-container',
                    store: dataStore,
                    width: '100%',
                    height: 500,
                    title: 'STAFF LIST',
                    columnLines: true,

                    viewConfig: {
                        forceFit: true,
                        emptyText: '<div style="text-align:center; padding:10px;">No records found</div>'
                    },

                    columns: [
                        {text: 'Name', dataIndex: 'name', flex: 1.5},
                        {text: 'Code', dataIndex: 'code', flex: 1},
                        {text: 'User Type', dataIndex: 'userType', flex: 1},
                        {text: 'PHONE', dataIndex: 'phone', flex: 1},
                        {text: 'Department', dataIndex: 'department', flex: 1.5},
                        {text: 'Status', dataIndex: 'status', flex: 1},
                        {text: 'Joining Date', dataIndex: 'joiningDate', flex: 1}
                    ],
                    tbar: [
                        {
                            xtype: 'textfield',
                            emptyText: 'Search Name...',
                            width: 200,
                            enableKeyEvents: true,
                            listeners: {
                                keyup: function(field) {
                                    var val = field.getValue();
                                    dataStore.clearFilter();
                                    if(val) dataStore.filter('name', val, true, false);
                                }
                            }
                        },
                        {
                            xtype: 'textfield',
                            emptyText: 'Search Code...',
                            width: 100,
                            enableKeyEvents: true,
                            listeners: {
                                keyup: function(field) {
                                    var val = field.getValue();
                                    dataStore.clearFilter();
                                    if(val) dataStore.filter('code', val, true, false);
                                }
                            }
                        },
                        {
                            xtype: 'textfield',
                            emptyText: 'Department',
                            width: 200,
                            enableKeyEvents: true,
                            listeners: {
                                keyup: function(field) {
                                    var val = field.getValue();
                                    dataStore.clearFilter();
                                    if(val) dataStore.filter('department', val, true, false);
                                }
                            }
                        },
                        {
                            xtype: 'textfield',
                            emptyText: 'Status',
                            width: 100,
                            enableKeyEvents: true,
                            listeners: {
                                keyup: function(field) {
                                    var val = field.getValue();
                                    dataStore.clearFilter();
                                    if(val) dataStore.filter('status', val, true, false);
                                }
                            }
                        },
                    ],

                    bbar: {
                        xtype: 'pagingtoolbar',
                        store: dataStore,
                        displayInfo: true,
                        displayMsg: 'Displaying {0} - {1} of {2}',
                        emptyMsg: 'No records'
                    }
                });
            });
        };
        Ext.onReady(function() {
            window.initTab3();
        });
    </script>
</body>
</html>