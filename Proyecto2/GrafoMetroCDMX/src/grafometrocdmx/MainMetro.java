package grafometrocdmx;

import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Scanner;

/**
 *
 * @author super
 */
public class MainMetro {

    public static void main(String[] args) {
        
        String csvFile = "lineasmetro.csv";
        BufferedReader br;
        String fila;
        ArrayList<Estacion> estaciones = new ArrayList<Estacion>(); 
        Estacion est;
        try{
            br = new BufferedReader(new FileReader(csvFile));
            while((fila = br.readLine()) != null){
                String[] datos = fila.split(",");
                est = new Estacion(datos[2],Double.parseDouble(datos[3]),Double.parseDouble(datos[4]));
                if(!estaciones.contains(est)){
                    estaciones.add(est);
                }
            }
        }
        catch(Exception e){
            System.out.println("ARCHIVO NO ENCONTRADO");
        }
        
        GrafoEstaciones metroCDMX = new GrafoEstaciones(estaciones.size());
        
        for(Estacion elemento : estaciones){
            metroCDMX.agregaEstacion(elemento);
        }
        
        metroCDMX.llenaLista();
        Estacion[] estArr = metroCDMX.getEstaciones();
        Estacion actualAux = null, destinoAux = null;
        int distanciaAux = 0;
        try{
            br = new BufferedReader(new FileReader(csvFile));
            while((fila = br.readLine()) != null){
                String[] datos = fila.split(",");
                actualAux = new Estacion(datos[2],Double.parseDouble(datos[3]),Double.parseDouble(datos[4]));
                if(distanciaAux != -1 && destinoAux != null){
                    int index1 = metroCDMX.buscaEstacion(actualAux);
                    int index2 = metroCDMX.buscaEstacion(destinoAux);
                    if (index1 != -1 && index2 != -1 && index1 != index2){
                        actualAux = estArr[metroCDMX.buscaEstacion(actualAux)];
                        destinoAux = estArr[metroCDMX.buscaEstacion(destinoAux)];
                        metroCDMX.agregaVia(actualAux, destinoAux, distanciaAux);
                    //System.out.println(actualAux.getNombre()+"-->"+destinoAux.getNombre()+": "+distanciaAux);
                    }
                    else {
                        System.out.println("NO SE PUEDE CREAR VÍA");
                        break;
                    }
                }
                distanciaAux = Integer.parseInt(datos[5]);
                destinoAux = actualAux;
            }
        }
        catch(Exception e){
            System.out.println("ARCHIVO NO ENCONTRADO");
        }
        
        System.out.println("Todas las estaciones son: ");
        System.out.println(metroCDMX.idNom());
        
        Scanner sc = new Scanner(System.in);
        System.out.println("Ingresa el id de la estación origen: ");
        int idOri = sc.nextInt();
        while (idOri >= estaciones.size()) {
            System.out.println("Id no encontrado");
            System.out.println("Ingresa el id de la estación origen: ");
            idOri = sc.nextInt();
        }
        System.out.println("Ingresa el id de la estación destino: ");
        int idDest = sc.nextInt();
        while (idDest >= estaciones.size()) {
            System.out.println("Id no encontrado");
            System.out.println("Ingresa el id de la estación destino: ");
            idDest = sc.nextInt();
        }
                
        Estacion origen = estArr[idOri];
        Estacion destino = estArr[idDest];
        ArrayList<Estacion> camino = metroCDMX.aEstrellaGeo(origen, destino);
        System.out.println("");
        System.out.println("El camino por recorrer es: ");
        if (camino.isEmpty()){
            System.out.println("No existe camino.");
        }
        else {
            for(Estacion path : camino){
                System.out.println(path.getNombre());
            }
        }
        
        //System.out.print(metroCDMX.toString());
        
        /*
        //PRUEBA1
        Estacion A = new Estacion("A",0,0);
        Estacion B = new Estacion("B",0,2);
        Estacion C = new Estacion("C",0,4);
        Estacion D = new Estacion("D",1,1);
        Estacion E = new Estacion("E",1,3);
        
        GrafoEstaciones prueba = new GrafoEstaciones(5);
        
        prueba.agregaEstacion(A);
        prueba.agregaEstacion(B);
        prueba.agregaEstacion(C);
        prueba.agregaEstacion(D);
        prueba.agregaEstacion(E);
        
        prueba.llenaLista();
        
        prueba.agregaVia(A, B, 20);
        prueba.agregaVia(A, D, 23);
        prueba.agregaVia(B, D, 2);
        prueba.agregaVia(B, C, 20);
        prueba.agregaVia(C, E, 15);
        */
        
        /* 
        //PRUEBA 2
        Estacion e1 = new Estacion("e1",0,0);
        Estacion e2 = new Estacion("e2",-1,-1);
        Estacion e3 = new Estacion("e3",-1,1);
        Estacion e4 = new Estacion("e4",0,1);
        Estacion e5 = new Estacion("e5",1,1);
        Estacion e6 = new Estacion("e6",1,2);
        Estacion e7 = new Estacion("e7",1,-1);
        Estacion e8 = new Estacion("e8",2,0);
        
        GrafoEstaciones prueba = new GrafoEstaciones(8);
        
        prueba.agregaEstacion(e1);
        prueba.agregaEstacion(e2);
        prueba.agregaEstacion(e3);
        prueba.agregaEstacion(e4);
        prueba.agregaEstacion(e5);
        prueba.agregaEstacion(e6);
        prueba.agregaEstacion(e7);
        prueba.agregaEstacion(e8);
        
        prueba.llenaLista();
        
        prueba.agregaVia(e1, e2, 10);
        prueba.agregaVia(e1, e3, 15);
        prueba.agregaVia(e1, e7, 13);
        prueba.agregaVia(e1, e5, 20);
        prueba.agregaVia(e2, e7, 19);
        prueba.agregaVia(e3, e4, 7);
        prueba.agregaVia(e4, e5, 10);
        prueba.agregaVia(e5, e7, 12);
        prueba.agregaVia(e5, e6, 15);
        prueba.agregaVia(e6, e8, 13);
        prueba.agregaVia(e7, e8, 6);
        prueba.agregaVia(e3, e6, 11);
        */
        
    }
    
}
