package patient.service;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import patient.entity.Patient;
import patient.entity.genderType.GenderTypes;
import patient.entity.prefixType.PrefixTypes;
import patient.entity.titleType.TitleType;
import patient.repository.PatientRepository;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    public void createPrefix(String title, String name, Date dob, String gender, String prefixName) {
        try {
            Patient patient = new Patient();
            // Use a safer conversion or ensure exact matches
            patient.setTitle(TitleType.valueOf(title.toUpperCase().trim()));
            patient.setName(name);
            patient.setDob(dob);
            patient.setGender(GenderTypes.valueOf(gender.toUpperCase().trim()));
            patient.setPrefix(PrefixTypes.valueOf(prefixName.toUpperCase().trim()));

            patientRepository.save(patient);
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Invalid selection for Title, Gender, or Prefix: " + e.getMessage());
        }
    }

    public List<Patient> searchWithFilters(String title, String name, Date dobFrom, Date dobTo, String gender, String prefix) {
        return patientRepository.findWithFilters(title, name, dobFrom, dobTo, gender, prefix);
    }

    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }
    public void deletePatientById(int id) {
        patientRepository.deleteById(id);
    }
    public void deleteAll() {
        patientRepository.deleteAll();
    }
}