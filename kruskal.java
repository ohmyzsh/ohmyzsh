import java.util.*;

class kruskal{
    int parent[] = new int[10];
    int find(int i){
        int p = i;
        while(parent[p]!=0)
            p = parent[p];
        return p;
    }

    void union(int i,int j){
        if(i<j)
        parent[i]=j;
        else
        parent[j]=i;

    }

    void krskl(int arr[][],int size){
        int i,j,k=0,u=0,v=0,min,sum=0;

        while(k!=size-1){
            min = 99;

            for(i=0;i<size;i++)
                for(j=0;j<size;j++)
                    if(arr[i][j] < min && i!=j){
                        min = arr[i][j];
                        u = i;
                        v = j;
                    }
                    i = find(u);
                    j = find(v);

                    if(i!=j){
                        union(i,j);
                        System.out.println("("+u+","+"v"+")"+"="+arr[u][v]);
                        sum = sum +arr[u][v];
                        k++;
                    }

                    arr[u][v]=arr[v][u]= 99;
                }
                System.out.println("The cost of minimum spanning tree = "+sum);
            }

    }


public class kruskal1{
    public static void main(String[] args){
        int arr[][] = new int[10][10];
        Scanner in = new Scanner(System.in);
        System.out.println("Enter the size of the array");
        int size = in.nextInt();
        int i,j;
        System.out.println("Enter the array Elements");
        for(i=0;i<size;i++)
        for(j=0;j<size;j++)
        arr[i][j] = in.nextInt();
        kruskal k = new kruskal();
        k.krskl(arr, size);

        in.close();
    }
}
