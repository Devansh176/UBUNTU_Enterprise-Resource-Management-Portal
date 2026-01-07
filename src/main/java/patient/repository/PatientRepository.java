package patient.repository;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import patient.entity.Patient;

import java.util.Date;
import java.util.List;

@Component
public class PatientRepository {

    @Autowired
    private SessionFactory sessionFactory;

    private Session getCurrentSession() { return sessionFactory.getCurrentSession(); }

    public void save(Patient patient) {
        getCurrentSession().save(patient);
        getCurrentSession().flush();
    }

    @SuppressWarnings("unchecked")
    public List<Patient> findAll(){ return getCurrentSession().createQuery("from Patient").list(); }

    public void deleteById(int id) {
        Session session = getCurrentSession();
        Patient patient = session.get(Patient.class, id);
        if(patient != null) session.delete(patient);
    }

    public void deleteAll() {
        getCurrentSession().createQuery("TRUNCATE TABLE Patient").executeUpdate();
    }

    @SuppressWarnings("unchecked")
    public List<Patient> findWithFilters(String title, String name, Date dobFrom, Date dobTo, String gender, String prefixName) {
        StringBuilder hql = new StringBuilder("FROM Patient WHERE 1=1 ");

        // Text Filters
        if (title != null && !title.trim().isEmpty()) hql.append("AND lower(str(title)) LIKE :title ");
        if (name != null && !name.trim().isEmpty()) hql.append("AND lower(name) LIKE :name ");
        if (gender != null && !gender.trim().isEmpty()) hql.append("AND lower(str(gender)) LIKE :gender ");
        if (prefixName != null && !prefixName.trim().isEmpty()) hql.append("AND lower(str(prefix)) LIKE :prefix ");

        if (dobFrom != null) {
            hql.append("AND dob >= :dobFrom ");
        }

        if (dobTo != null) {
            hql.append("AND dob <= :dobTo ");
        }

        var query = getCurrentSession().createQuery(hql.toString());

        // Set Parameters
        if (title != null && !title.trim().isEmpty()) query.setParameter("title", "%" + title.toLowerCase() + "%");
        if (name != null && !name.trim().isEmpty()) query.setParameter("name", "%" + name.toLowerCase() + "%");
        if (gender != null && !gender.trim().isEmpty()) query.setParameter("gender", "%" + gender.toLowerCase() + "%");
        if (prefixName != null && !prefixName.trim().isEmpty()) query.setParameter("prefix", "%" + prefixName.toLowerCase() + "%");

        // Bind Dates
        if (dobFrom != null) query.setParameter("dobFrom", dobFrom);
        if (dobTo != null) query.setParameter("dobTo", dobTo);

        return query.list();
    }
}