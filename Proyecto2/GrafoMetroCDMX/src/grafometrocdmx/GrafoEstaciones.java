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
                /*for (Estacion est:openList){
                    System.out.print(est.getNombre()+":"+est.getDistAcum()+ " --> ");
                }
                System.out.println("");*/
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
