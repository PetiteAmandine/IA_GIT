package grafometrocdmx;

import java.util.ArrayList;

/**
 *
 * @author super
 */
public class MainMetro {

    public static void main(String[] args) {
        /*PRUEBA1     
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
        
        //prueba.agregaVia(e1, e2, 10);
        prueba.agregaVia(e1, e3, 15);
        prueba.agregaVia(e1, e7, 13);
        prueba.agregaVia(e1, e5, 20);
        //prueba.agregaVia(e2, e7, 19);
        prueba.agregaVia(e3, e4, 7);
        prueba.agregaVia(e4, e5, 10);
        prueba.agregaVia(e5, e7, 12);
        prueba.agregaVia(e5, e6, 15);
        prueba.agregaVia(e6, e8, 13);
        prueba.agregaVia(e7, e8, 6);
        prueba.agregaVia(e3, e6, 11);
        
        
        ArrayList<Estacion> camino = prueba.aEstrellaR(e4, e2);
        
        if (camino.size() == 0)
            System.out.println("No existe camino.");
        else 
            for(Estacion est : camino){
                System.out.println(est.getNombre());
        }
        
       
        //System.out.print(prueba.toString());

    }
    
}
