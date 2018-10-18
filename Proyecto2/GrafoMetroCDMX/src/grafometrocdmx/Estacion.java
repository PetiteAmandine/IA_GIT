package grafometrocdmx;

import java.util.Objects;

/**
 *
 * @author super
 */
public class Estacion {
    
    private String nombre;
    private double latitud;
    private double longitud;
    private double distAcum;
    private int id;

    public Estacion(){
        
    }
    
    public Estacion(String nombre, double latitud, double longitud) {
        this.nombre = nombre;
        this.latitud = latitud;
        this.longitud = longitud;
        this.distAcum = 0;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public double getLatitud() {
        return latitud;
    }

    public void setLatitud(double latitud) {
        this.latitud = latitud;
    }

    public double getLongitud() {
        return longitud;
    }

    public void setLongitud(double longitud) {
        this.longitud = longitud;
    }
    
    public double getDistAcum() {
        return distAcum;
    }
    
    public void setDistAcum(double distAcum) {
        this.distAcum = distAcum;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Estacion other = (Estacion) obj;
        if (Double.doubleToLongBits(this.latitud) != Double.doubleToLongBits(other.latitud)) {
            return false;
        }
        if (Double.doubleToLongBits(this.longitud) != Double.doubleToLongBits(other.longitud)) {
            return false;
        }
        if (!Objects.equals(this.nombre, other.nombre)) {
            return false;
        }
        return true;
    }

    

    @Override
    public String toString() {
        return "Estacion{"+"id=" + id + "nombre=" + nombre + ", latitud=" + latitud + ", longitud=" + longitud + '}';
    }
        
}
