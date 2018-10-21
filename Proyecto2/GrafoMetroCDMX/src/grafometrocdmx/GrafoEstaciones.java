package grafometrocdmx;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.Queue;

/**
 *
 * @author super
 */
public class GrafoEstaciones {
    
    private ArrayList<ArrayList<Vias>> lineas;
    private Estacion[] estaciones;
    private HashSet<Estacion> visitados;
    private int numEst;
    private int tamMax;
    
    public GrafoEstaciones(int tam){
        lineas = new ArrayList<ArrayList<Vias>>();
        estaciones = new Estacion[tam];
        numEst = 0; 
        tamMax = tam;
        visitados = new HashSet<Estacion>();
    }

    
    public int buscaEstacion(Estacion aux){
        int clave = -1;
        for (int i = 0; i < estaciones.length; i++){
            if(estaciones[i].equals(aux)){
                clave = i;
                break;
            }
        }
        return clave;
    }
    
    public int getNumEst() {
        return numEst;
    }
    
    public Estacion getEstacion(int id){
        return estaciones[id];
    }
    
    public Estacion[] getEstaciones(){
        return estaciones;
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
   
    private double haversin(double val){
        return Math.pow(Math.sin(val/2), 2);
    }
    private double distHaversine(Estacion actual, Estacion destino){
        double long1,long2,lat1,lat2;
        long1 = actual.getLongitud();
        long2 = destino.getLongitud();
        lat1 = actual.getLatitud();
        lat2 = destino.getLatitud();
        //double c = Math.PI/180;
        //double d = (2*6367.45*Math.asin(Math.sqrt(Math.pow(Math.sin(c*(lat2-lat1)/2),2)+Math.cos(c*lat1)*Math.cos(c*lat2)*Math.pow(Math.sin(c*(long2-long1)/2),2))));
        double dLat = Math.toRadians(lat2-lat1);
        double dLong = Math.toRadians(long2-long1);
        lat1 = Math.toRadians(lat1);
        lat2 = Math.toRadians(lat2);
        double a = haversin(dLat)+Math.cos(lat1)*Math.cos(lat2)*haversin(dLong);
        double c = 2*Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        double d = 6371*c;
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
    private Map<Estacion, Double> initializeAllToInfinity() {
        Map<Estacion,Double> distances = new HashMap<>();
        for(int i = 0; i < estaciones.length; i++){
            distances.put(estaciones[i], Double.POSITIVE_INFINITY);
        }
        return distances;
    }
    private double calculaF(Estacion actual, Estacion destino, Estacion destinoFinal){
        ArrayList<Vias> aux = lineas.get(actual.getId());
        double f = 0, g = 0, h = 0;
        for(int i = 0; i < aux.size(); i++){
            g = actual.getDistAcum();   
            if(aux.get(i).getEstD().equals(destino)){
                g = g + aux.get(i).getDistancia();
                h = distHaversine(destino,destinoFinal);
                f = g + h;
                //System.out.println(actual.getNombre()+"-->"+destino.getNombre()+": g="+g+", h="+h+" f="+f);
                break;
            }
        }
        return f;
    }
    private PriorityQueue<Estacion> initQueue() {
        return new PriorityQueue<>(10, new Comparator<Estacion>() {
            public int compare(Estacion x, Estacion y) {
                if (x.getCostoTotal()< y.getCostoTotal()) {                   
                    return -1;              
                }              
                if (x.getCostoTotal()> y.getCostoTotal()) {
                    return 1;
                }
                return 0;
            };
        });
    }
    private ArrayList<Estacion> obtieneCamino(HashMap<Estacion,Estacion> padres, Estacion origen, Estacion destino){
        ArrayList<Estacion> camino = new ArrayList<Estacion>();
        Estacion actual = destino;
        while(!actual.equals(origen)){
            camino.add(0,actual);
            actual = padres.get(actual);
        }
        camino.add(0,actual);
        return camino;
    }
    public ArrayList<Estacion> aEstrellaGeo(Estacion origen, Estacion destino){
        HashMap<Estacion,Estacion> padres = new HashMap<Estacion,Estacion>();
        Map<Estacion, Double> efes = initializeAllToInfinity();
        Queue<Estacion> colaP = initQueue();
        
        efes.put(origen, origen.getCostoTotal());
        colaP.add(origen);
        while(!colaP.isEmpty()){
            Estacion actual = colaP.poll();
            if(!visitados.contains(actual)){
                visitados.add(actual);
                if(actual.equals(destino)){
                    ArrayList<Estacion> camino = obtieneCamino(padres, origen, destino);
                    return camino;
                }
                ArrayList<Vias> subsecuentes = lineas.get(actual.getId());
                for(Vias elemento : subsecuentes){
                    if(!visitados.contains(elemento.getEstD())){
                        double h = distHaversine(elemento.getEstD(),destino);
                        double gInc = distVias(actual,elemento.getEstD());
                        double g = gInc + elemento.getEstD().getDistAcum();
                        double f = g + h;
                        if(f < efes.get(elemento.getEstD())){
                            efes.put(elemento.getEstD(), f);
                            elemento.getEstD().setCostoTotal(f);
                            elemento.getEstD().setDistAcum(g);
                            //System.out.println(elemento.getEstD().getNombre()+": "+elemento.getEstD().getDistAcum());
                            padres.put(elemento.getEstD(), actual);
                            colaP.add(elemento.getEstD());
                        }
                    }
                }
            }
        }
        return null;
        
    }
    /*
    private class Bandera {
        boolean terminado;
    }
    public ArrayList<Estacion> aEstrellaR(Estacion actual, Estacion destino){
        ArrayList<Estacion> path = new ArrayList<Estacion>();
        Bandera complete = new Bandera();
        complete.terminado = false;
        aEstrellaR(actual, destino, new ArrayList<Estacion>(), path, complete);
        return path;
    }
    private void aEstrellaR(Estacion actual, Estacion destino, ArrayList<Estacion> openList, ArrayList<Estacion> closeList, Bandera complete){
        openList.add(actual);
        visitados[actual.getId()] = 1;
        if(actual.equals(destino)){
            complete.terminado = true;
            for (Estacion est : openList){
                closeList.add(est);
            }
            return ;
        }
        if(openList.isEmpty()){
            return ;
        }
        while (complete.terminado == false) {
            ArrayList<Vias> subsecuentes = lineas.get(actual.getId());
            Estacion nueva = null;
            double menor = Integer.MAX_VALUE;
            for(Vias hijo : subsecuentes){
                if(visitados[hijo.getEstD().getId()] == 0){
                    double f = calculaF(actual, hijo.getEstD(), destino);
                    //System.out.println(actual.getNombre()+"-->"+hijo.getEstD().getNombre()+":"+f);
                    if(f < menor){
                        menor = f;
                        nueva = hijo.getEstD();
                    }
                }
            }
            if (nueva != null){
                //for (Estacion est:openList){
                //    System.out.print(est.getNombre()+":"+est.getDistAcum()+ " --> ");
                //}
                //System.out.println("");
                for (Vias via : subsecuentes){
                    if(via.getEstD().equals(nueva)){
                        nueva.setDistAcum(actual.getDistAcum() + via.getDistancia());
                        break;
                    }
                }
                aEstrellaR(nueva, destino, openList, closeList, complete);
            }
            else {
                openList.remove(openList.size()-1);
                return;
            }
        }
    }
    */
    
    public String idNom(){
        StringBuilder res = new StringBuilder();
        for(int i = 0; i < numEst; i++){
            res.append(estaciones[i].getId()+": \t"+estaciones[i].getNombre()+"\n");
        }
        return res.toString();
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
