<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .tab1-container {
        padding: 20px;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 4px;
        max-width: 800px
    }

    .tab1-title {
        font-size: 16px;
        font-weight: bold;
        color: #333;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 1px solid #eee;
    }

    .form-row {
        display: flex;
        gap: 30px;
        margin-bottom: 15px;
        align-items: flex-start;
    }

    .input-group {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .input-group label {
        font-weight: 600;
        font-size: 13px;
        color: #555;
    }

    .html-select {
         height: 32px;
         width: 200px;
         padding: 0 10px;
         border: 1px solid #ccc;
         border-radius: 3px;
         background-color: white;
    }
</style>

<div class="tab1-container">
    <div class="tab1-title">
        Tab1 : Standard HTML select & ExtJS Dropdown
    </div>

    <div class="form-row">
        <div class="input-group">
            <label> DEPARTMENT </label>
            <select class="html-select">
                <option value="">Select Department</option>
                <option value="Pathology">Pathology</option>
                <option value="Cardiology">Cardiology</option>
                <option value="Neurology">Neurology</option>
                <option value="Radiology">Neurology</option>
            </select>
        </div>

        <div class="input-group">
            <label>STATIC VALUE</label>
            <div id="extDropdownContainer"></div>
        </div>
    </div>
</div>

<script type="text/javascript">
    Ext.onReady(function() {
        var targetDiv = document.getElementById('extDropdownContainer');
        if(targetDiv) targetDiv.innerHTML = "";

        var staticStore = Ext.create('Ext.data.Store', {
            fields: ['name'],
            data: [
                { "name": "STATIC VALUE 1" },
                { "name": "STATIC VALUE 2" },
                { "name": "STATIC VALUE 3" },
                { "name": "DEPARTMENT A" },
                { "name": "DEPARTMENT B" },
                { "name": "DEPARTMENT C" },
                { "name": "DEPARTMENT D" }
            ]
        });

        Ext.create('Ext.form.field.ComboBox', {
            renderTo: 'extDropdownContainer',
            width: 200,
            store: staticStore,
            queryMode: 'local',
            displayField: 'name',
            valueField: 'name',
            emptyText: 'Type to search...',
            editable: true,
            typeAhead: true,
            forceSelection: true,

            style: {
                marginBottom: '0px'
            }
        });
    });
</script>