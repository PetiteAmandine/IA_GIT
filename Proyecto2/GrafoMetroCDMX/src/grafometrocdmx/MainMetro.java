package grafometrocdmx;

import java.util.ArrayList;

/**
 *
 * @author super
 */
public class MainMetro {

    public static void main(String[] args) {
             
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
        
        
        ArrayList<Estacion> camino = prueba.aEstrellaR(A, E);
        for(Estacion est : camino){
            System.out.println(est.getNombre());
        }
        
        
        //System.out.print(prueba.toString());

    }
    
}
