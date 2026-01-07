package patient.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import patient.entity.Patient;
import patient.service.PatientService;

import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/api")
public class WebServiceController {

    @Autowired
    private PatientService patientService;

    @PostMapping("/patient")
    public String createPatient (
            @RequestParam("title") String title,
            @RequestParam("name") String name,
            @RequestParam("dob") @DateTimeFormat(pattern = "yyyy-MM-dd") Date dob,
            @RequestParam("gender") String gender,
            @RequestParam("prefix") String prefixName) {
        try {
            patientService.createPrefix(title, name, dob, gender, prefixName);
            System.out.println("Data created"+title+""+name+""+dob+""+gender+""+prefixName);
            return "{ \"success\": true, \"message\": \"Record Created Successfully\" }";
        }
        catch (Exception e) {
            return "{ \"success\": false, \"message\": \"Error: " + e.getMessage() + "\" }";
        }
    }

    @GetMapping("/patients")
    public List<Patient> getPatientsJson() {
        return patientService.getAllPatients();
    }

    @DeleteMapping("/patient/{id}")
    public String deletePrefix(@PathVariable("id") int id) {
        try {
            patientService.deletePatientById(id);
            return "{ \"success\": true, \"message\": \"Record Deleted Successfully\" }";
        }
        catch (Exception e) {
            e.printStackTrace();
            return "{ \"success\": false, \"message\": \"Error: " + e.getMessage() + "\" }";
        }
    }
}