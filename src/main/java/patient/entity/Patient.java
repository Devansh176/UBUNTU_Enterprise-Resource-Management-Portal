package patient.entity;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.springframework.context.annotation.ComponentScan;
import patient.entity.genderType.GenderTypes;
import patient.entity.prefixType.PrefixTypes;
import patient.entity.titleType.TitleType;

import java.util.Date;

@Entity
//@Getter
//@Setter
//@NoArgsConstructor
//@AllArgsConstructor
@Table(name = "Patient")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "NAME")
    private String name;

    @Column(name = "DOB")
    @Temporal(TemporalType.DATE)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private Date dob;

    @Column(name = "GENDER")
    @Enumerated(EnumType.STRING)
    private GenderTypes gender;

    @JsonIgnore
    @Column(name = "PREFIX_NAME")
    @Enumerated(EnumType.STRING)
    private PrefixTypes prefix;

    @JsonProperty("prefix")
    public String getDisplayPrefix() {
        if (prefix != null) {
            return prefix.getDisplayValue();
        }
        return "";
    }

    @JsonIgnore
    @Column(name = "TITLE")
    @Enumerated(EnumType.STRING)
    private TitleType title;

    @JsonProperty("title")
    public String getDisplayTitle() {
        if(title != null) {
            return title.getDisplayValue();
        }
        return "";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public GenderTypes getGender() {
        return gender;
    }

    public void setGender(GenderTypes gender) {
        this.gender = gender;
    }

    public PrefixTypes getPrefix() {
        return prefix;
    }

    public void setPrefix(PrefixTypes prefix) {
        this.prefix = prefix;
    }

    public TitleType getTitle() {
        return title;
    }

    public void setTitle(TitleType title) {
        this.title = title;
    }
}












