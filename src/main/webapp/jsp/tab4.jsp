<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .form-box {
        background: white;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 4px;
        display: flex;
        gap: 15px;
        align-items: flex-end;
        flex-wrap: wrap;
    }

    .field-col {
        display: flex;
        flex-direction: column;
        gap: 5px;
    }

    .field-col label {
        font-weight: 600;
        font-size: 13px;
        color: #555;
    }

    .ext-slot {
        width: 160px;
    }

    .std-input {
        height: 32px;
        width: 200px;
        padding: 0 10px;
        border: 1px solid #ccc;
        border-radius: 3px;
    }

    .btn {
        height: 32px;
        padding: 0 20px;
        border: none; border-radius: 3px;
        cursor: pointer;
        color: white; font-weight: bold;
    }
    .btn-green { background: #27ae60; }
    .btn-red { background: #c0392b; }

    .table-wrapper {
        max-height: 500px;
        overflow-y: auto;
        border: 1px solid #eee;
        margin-top: 20px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        display: block;
        width: 100%;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
        border: none;
    }

    .data-table th {
        background: #f0f2f5;
        padding: 12px;
        text-align: left;
        border-bottom: 2px solid #ddd;
        position: sticky;
        top: 0;
        z-index: 10;
    }
    .data-table td {
        padding: 10px;
        border-bottom: 1px solid #f9f9f9;
    }

    .filter-box {
        width: 90%;
        margin-top: 5px;
        padding: 4px;
    }
</style>

<h3>1. New Record</h3>
<div class="form-box">
    <div class="field-col"><label>Title</label><div id="slot-title" class="ext-slot"></div></div>
    <div class="field-col"><label>Full Name</label><input type="text" id="input-name" class="std-input"></div>
    <div class="field-col"><label>DOB</label><div id="slot-dob" class="ext-slot"></div></div>
    <div class="field-col"><label>Gender</label><div id="slot-gender" class="ext-slot"></div></div>
    <div class="field-col"><label>Prefix</label><div id="slot-prefix" class="ext-slot"></div></div>

    <div style="margin-left: auto; display:flex; gap:10px;">
        <button class="btn btn-green" onclick="PatientManager.save()">Save</button>
        <button class="btn btn-red" onclick="PatientManager.deleteAll()">Delete All</button>
    </div>
</div>

<h3>2. Records List</h3>
<div style="display:flex; gap:10px; align-items:center; margin-bottom:10px; background:#f9f9f9; padding:10px;">
    <strong>Filter DOB:</strong> <div id="filter-from"></div> <span>to</span> <div id="filter-to"></div>
    <a href="#" onclick="PatientManager.clearDates()" style="margin-left:10px;">Clear Dates</a>
    <button class="btn btn-green" style="height:25px; line-height:10px;" onclick="PatientManager.search()">Go</button>
</div>

<div class="table-wrapper">
    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Title <br><input id="s-title" class="filter-box" onchange="PatientManager.search()"></th>
                <th>Name <br><input id="s-name" class="filter-box" onchange="PatientManager.search()"></th>
                <th>DOB</th>
                <th>Gender <br><input id="s-gender" class="filter-box" onchange="PatientManager.search()"></th>
                <th>Prefix <br><input id="s-prefix" class="filter-box" onchange="PatientManager.search()"></th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody id="grid-body"></tbody>
    </table>
</div>


<script>
    window.PatientManager = (function() {
        var cmpTitle, cmpDob, cmpGender, cmpPrefix, cmpFrom, cmpTo;

        Ext.onReady(function() {
            if(document.getElementById('slot-title').innerHTML !== "") return;

            cmpTitle = createCombo('slot-title', ['MR', 'MRS', 'MS', 'DR', 'MX', 'PROF']);
            cmpGender = createCombo('slot-gender', ['MALE', 'FEMALE', 'OTHER']);
            cmpPrefix = createCombo('slot-prefix', ['SO', 'DO', 'WO', 'HO', 'MO', 'FO']);

            cmpDob = Ext.create('Ext.form.field.Date', {
                renderTo: 'slot-dob',
                format: 'Y-m-d',
                maxValue: new Date(),
                width: '100%'
            });

            cmpFrom = Ext.create('Ext.form.field.Date', {
                id: 'tab4DateFrom',
                renderTo: 'filter-from',
                format: 'Y-m-d',
                width: 130
            });

            cmpTo = Ext.create('Ext.form.field.Date', {
                id: 'tab4DateTo',
                renderTo: 'filter-to',
                format: 'Y-m-d',
                width: 130
            });
            search();
        });

        function createCombo(divId, data) {
            return Ext.create('Ext.form.field.ComboBox', {
                renderTo: divId,
                store: data,
                emptyText: 'Select',
                width: '100%',
                editable: false
            });
        }

        function search() {
            var rawTitle = document.getElementById('s-title').value;
            var rawName = document.getElementById('s-name').value;
            var rawGender = document.getElementById('s-gender').value;
            var rawPrefix = document.getElementById('s-prefix').value;

            var tVal = rawTitle.trim() === "" ? null : rawTitle;
            var nVal = rawName.trim() === "" ? null : rawName;
            var gVal = rawGender.trim() === "" ? null : rawGender;
            var pVal = rawPrefix.trim() === "" ? null : rawPrefix.toUpperCase();

            var dFrom = cmpFrom ? cmpFrom.getValue() : null;
            var dTo = cmpTo ? cmpTo.getValue() : null;

            if (typeof PatientController !== 'undefined' && typeof PatientController.search === 'function') {
                PatientController.search(tVal, nVal, dFrom, dTo, gVal, pVal, {
                    callback: renderTable,
                    errorHandler: function(e) { console.error("DWR Error:", e); }
                });
            } else {
                console.error("PatientController.search is missing. Please restart Tomcat.");
            }
        }

        function renderTable(data) {
            var tbody = document.getElementById('grid-body');
            tbody.innerHTML = "";
            if (!data || data.length === 0) {
                tbody.innerHTML = "<tr><td colspan='7' style='text-align:center; padding:15px; color:#999;'>No records found</td></tr>";
                return;
            }
            data.forEach(function(row) {
                var tr = document.createElement('tr');
                tr.id = 'row-' + row.id;
                var dob = row.dob ? Ext.Date.format(new Date(row.dob), 'd-M-Y') : "";

                var title = row.displayTitle || "";

                tr.innerHTML =
                    "<td>" + row.id + "</td>" +
                    "<td>" + title + "</td>" +
                    "<td><b>" + (row.name||"") + "</b></td>" +
                    "<td>" + dob + "</td>" +
                    "<td>" + (row.gender||"") + "</td>" +
                    "<td>" + (row.prefix||"") + "</td>" +
                    "<td style='text-align:center;'><button onclick='PatientManager.deleteRec(" + row.id + ")' style='color:red;border:none;background:none;cursor:pointer;'>✖</button></td>";
                tbody.appendChild(tr);
            });
        }

        return {
            search: search,
            save: function() {
                var vName = document.getElementById('input-name').value;
                if (!vName) {
                    alert("Enter Name");
                    return;
                }
                PatientController.savePatient(
                    cmpTitle.getValue(),
                    vName,
                    cmpDob.getValue(),
                    cmpGender.getValue(),
                    cmpPrefix.getValue(),
                    {
                        callback: function() {
                            alert("Saved!");
                            document.getElementById('input-name').value="";
                            cmpTitle.reset();
                            cmpDob.reset();
                            cmpGender.reset();
                            cmpPrefix.reset();
                            search();
                        }
                    }
                );
            },
            deleteRec: function(id) {
                if (confirm("Delete?")) {
                    PatientController.deletePatient(id, {
                        callback: function() {
                            var row = document.getElementById('row-' + id);
                            if (row) row.remove();
                            search();
                        },
                        errorHandler: function(msg) {
                            alert("Error deleting record: " + msg);
                        }
                    });
                }
            },
            deleteAll: function() {
                if(confirm("Delete All?")) PatientController.deleteAll({callback:search});
            },
            clearDates: function() {
                cmpFrom.reset(); cmpTo.reset(); search();
            }
        };
    })();
</script>