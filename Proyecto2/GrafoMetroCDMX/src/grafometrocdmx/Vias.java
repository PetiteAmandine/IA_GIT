package grafometrocdmx;

/**
 *
 * @author super
 */
public class Vias {
    
    private Estacion estD;
    private int distancia;
    
    public Vias(Estacion siguiente, int dist){
        estD = siguiente;
        distancia = dist;
    }

    public Estacion getEstD() {
        return estD;
    }

    public void setEstD(Estacion estD) {
        this.estD = estD;
    }

    public int getDistancia() {
        return distancia;
    }

    public void setDistancia(int distancia) {
        this.distancia = distancia;
    }

    @Override
    public String toString() {
        return "Vias{" + "estD=" + estD.toString() + ", distancia=" + distancia + '}';
    }
       
}
