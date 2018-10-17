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
    private boolean todosVisitados(){
        for(int i = 0; i < visitados.length; i++){
            if(visitados[i] == 0){
                return false;
            }
        }
        return true;
    }
    private double calculaF(Estacion actual, Estacion destino){
        ArrayList<Vias> aux = lineas.get(actual.getId());
        double f = 0;
        for(int i = 0; i < aux.size(); i++){
            if(aux.get(i).getEstD().equals(destino)){
                f = aux.get(i).getEstD().getDistAcum() + aux.get(i).getDistancia() + distHaversine(actual,destino);
                break;
            }
        }
        return f;
    }
    public ArrayList<Estacion> aEstrellaR(Estacion actual, Estacion destino){
        ArrayList<Estacion> path = new ArrayList<Estacion>();
        aEstrellaR(actual, destino, new ArrayList<Estacion>(), path);
        return path;
    }
    private void aEstrellaR(Estacion actual, Estacion destino, ArrayList<Estacion> openList, ArrayList<Estacion> closeList){
        openList.add(actual);
        visitados[actual.getId()] = 1;
        if(actual.equals(destino)){
            for (Estacion est : openList){
                closeList.add(est);
            }
            return ;
        }
        if(todosVisitados() || openList.isEmpty()){
            return ;
        }
        ArrayList<Vias> subsecuentes = lineas.get(actual.getId());
        Estacion nueva = null;
        double menor = Integer.MAX_VALUE;
        for(Vias hijo : subsecuentes){
            if(visitados[hijo.getEstD().getId()] == 0){
                double f = calculaF(actual, hijo.getEstD());
                System.out.println(actual.getNombre()+"-->"+hijo.getEstD().getNombre()+":"+f);
                if(f < menor){
                    menor = f;
                    nueva = hijo.getEstD();
                }
            }
        }
        if (nueva != null){
            for (Estacion est:openList){
                System.out.print(est.getNombre()+":"+est.getDistAcum()+ " --> ");
            }
            System.out.println("");
            for (Vias via : subsecuentes){
                if(via.getEstD().equals(nueva)){
                    nueva.setDistAcum(actual.getDistAcum() + via.getDistancia());
                    break;
                }
            }
            aEstrellaR(nueva, destino, openList, closeList);
        }
    }
    /*
    private double calculaF(Estacion actual, Estacion destino){
        ArrayList<Vias> aux = lineas.get(actual.getId());
        double f = 0;
        for(int i = 0; i < aux.size(); i++){
            if(aux.get(i).getEstD().equals(destino)){
                f = aux.get(i).getDistancia() + distHaversine(actual,destino);
                break;
            }
        }
        return f;
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
        //El primer nodo en la lista es el nodo actual, solo la primera vez
        Estacion actual = openList.get(0);
        //Mientras la lista abierta no este vacia hay opciones por explorar
        while (!openList.isEmpty()) {
            //Hace del nodo actual el que menor F tenga dentro de la lista abierta
            double f = 0;
            for(int i = 0; i < openList.size(); i++){
                
            }
            //Actualiza el valor de F
            fAux = calculaF(actual,destino);
            //Elimina el nodo actual de la lista abierta
            openList.remove(actual.getId());
            //Añade el nodo actual a la lista cerrada
            closeList.add(actual);
            //Checa si el nodo actual no es el destino
            if(actual.equals(destino)){
                //Backtrack para encontrar el camino
            }
            //Busca los hijos del nodo actual
            ArrayList<Vias> subsecuentes = lineas.get(actual.getId());
            //Para cada hijo del nodo actual
            for(int i = 0; i < subsecuentes.size(); i++){
                //Revisa si no esta en la lista cerrada
                if(closeList.contains(subsecuentes.get(i).getEstD())){
                    //De estar se vuelve al incio del ciclo
                    continue;
                }
                //Calcula los nuevos valores de f, g, h
                gAux = subsecuentes.get(i).getDistancia();
                hAux = distHaversine(subsecuentes.get(i).getEstD(),destino);
                fAux = gAux + hAux;
                //Revisa si no está dentro de la lista abierta
                if(openList.contains(subsecuentes.get(i).getEstD())){
                    //Bandera para identificar cuando un hijo tenga mayor G que el actual
                    boolean bandera = false;
                    //Obtiene la G del hijo actual
                    double gHijo = subsecuentes.get(i).getDistancia();
                    //Para todos los hijos del nodo actual
                    for(int j = 0; j < subsecuentes.size(); j++){
                        //Checa si el hijo actual es, de entre todos, el de mayor G
                        if(gHijo > subsecuentes.get(j).getDistancia()){
                            //Pone bandera en true
                            bandera = true;
                        }
                    }
                    //Si la bandera es verdadera
                    if(bandera){
                        //Continua al inicio del ciclo for, el sgiuiente hijo
                        continue;
                    }
                }
                //Añade el nodo actual a la lista abierta
                openList.add(subsecuentes.get(i).getEstD());
                
            }
            
        }
        return closeList; //NO, SÓLO PARA QUITAR EL WARNING
    }
    */
    
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
