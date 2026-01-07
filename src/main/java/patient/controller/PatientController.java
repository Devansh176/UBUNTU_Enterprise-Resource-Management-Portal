package patient.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.format.annotation.DateTimeFormat;
import patient.entity.Patient;
import patient.service.PatientService;

import java.util.Date;
import java.util.List;

@Controller
public class PatientController {

    @Autowired
    private PatientService patientService;

    public void savePatient(String title, String name, Date dob, String gender, String prefixName) {
        patientService.createPrefix(title, name, dob, gender, prefixName);
        System.out.println("Data Received"+title+""+name+""+dob+""+gender+""+prefixName);
    }

    public List<Patient> listPatients() {
        return patientService.getAllPatients();

    }
    public void deletePatient(int id) {
        patientService.deletePatientById(id);
    }

    public void deleteAll() {
        patientService.deleteAll();
    }

    @GetMapping("/api/search")
    @ResponseBody
    public List<Patient> search(
            @RequestParam(required = false) String title,
            @RequestParam(required = false) String name,

            @RequestParam(required = false) @DateTimeFormat(pattern="yyyy-MM-dd") Date dobFrom,
            @RequestParam(required = false) @DateTimeFormat(pattern="yyyy-MM-dd") Date dobTo,

            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String prefix
    ) {
        // Pass both dates to service
        return patientService.searchWithFilters(title, name, dobFrom, dobTo, gender, prefix);
    }
}