package grafometrocdmx;
import java.util.ArrayList;

/**
 *
 * @author super
 */
public class GrafoEstaciones {
    
    private ArrayList<ArrayList<Vias>> lineas;
    private Estacion[] estaciones;
    private int[] visitados;
    private int numEst;
    private int tamMax;
    
    public GrafoEstaciones(int tam){
        lineas = new ArrayList<ArrayList<Vias>>();
        estaciones = new Estacion[tam];
        visitados = new int[tam];
        numEst = 0; 
        tamMax = tam;
        inicializaVisitados();
    }
    private void inicializaVisitados(){
        for(int i = 0; i < visitados.length; i++){
            visitados[i] = 0;
        }
    }
    
    public int getNumEst() {
        return numEst;
    }
    
    public void agregaEstacion(Estacion nueva){
        if (numEst < tamMax){
            estaciones[numEst] = nueva;
            nueva.setId(numEst);
            numEst++;
        }
    }
    
    public void llenaLista(){
        for(int i = 0; i < numEst; i++){
            ArrayList<Vias> popo = new ArrayList<Vias>();
            lineas.add(popo);
        }
    }
    
    public void agregaVia(Estacion est1, Estacion est2, int distancia){
        Vias nueva = new Vias(est2,distancia);
        lineas.get(est1.getId()).add(nueva);
        nueva = new Vias(est1, distancia);
        lineas.get(est2.getId()).add(nueva);
    }
    
    private double distHaversine(Estacion actual, Estacion destino){
        double c = Math.PI/180;
        double long1,long2,lat1,lat2;
        long1 = actual.getLongitud();
        long2 = destino.getLongitud();
        lat1 = actual.getLatitud();
        lat2 = destino.getLatitud();
        double d = (2*6367.45*Math.asin(Math.sqrt(Math.pow(Math.sin(c*(lat2-lat1)/2),2)+Math.cos(c*lat1)*Math.cos(c*lat2)*Math.pow(Math.sin(c*(long2-long1)/2),2))));
        return d*1000;
    }
    private double distVias(Estacion est1, Estacion est2){
        int idOri = est1.getId();
        ArrayList<Vias> temp = lineas.get(idOri);
        double distVias = 0;
        for(int i = 0; i < temp.size(); i++){
            if(est2.equals(temp.get(i).getEstD())){
                distVias = temp.get(i).getDistancia();
                break;
            }
        }
        return distVias;
    }
    private Estacion menorF(Estacion actual, Estacion destino, double fIni){
        ArrayList<Vias> subsecuentes = lineas.get(actual.getId());
        Estacion menor = new Estacion();
        double f = 0;
        for (int i = 0; i < subsecuentes.size(); i++){
            f = subsecuentes.get(i).getDistancia() + distHaversine(subsecuentes.get(i).getEstD(),destino);
            if(f < fIni){
                menor = subsecuentes.get(i).getEstD();
            }
        }
        return menor;
    }
    public ArrayList<Estacion> aEstrella(Estacion origen, Estacion destino){
        //Creo las dos listas para iterar sobre el grafo
        ArrayList<Estacion> openList = new ArrayList<Estacion>();
        ArrayList<Estacion> closeList = new ArrayList<Estacion>();
        double gAux = 0, hAux = 0, fAux = 0;
        //Añado el primer elemento a la lista abierta
        openList.add(origen);
        //Mientras la lista abierta no este vacia hay opciones por explorar
        while (!openList.isEmpty()) {
            
        }
        return closeList; //NO, SÓLO PARA QUITAR EL WARNING
    }
    
    public String toString() {
        ArrayList<Vias> temp;
        StringBuilder res = new StringBuilder();
        for (int i = 0; i < numEst; i++){
            temp = lineas.get(i);
            res.append(estaciones[i].getNombre()+": \t");
            for (int j = 0; j < temp.size(); j++){
                res.append("("+temp.get(j).getEstD().getNombre()+","+temp.get(j).getDistancia()+")"+",");
            }
            res.append("\n");
        }
        return res.toString();
    }
       
}
