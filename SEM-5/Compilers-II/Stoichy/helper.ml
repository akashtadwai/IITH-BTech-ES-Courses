let balance_head = "import functions.*;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.ArrayList;
import javax.swing.*;

public class "

let balance_mid = "{"

let balance_mid1 = "
    public static boolean debug = false;
    public static int randx;
    public static int randy;
    
    public "

let balance_mid15 = "(){"

let balance_mid2 = "} public static String Balance(String s)
    {
        String output = \"\";
        try {
        Process p = Runtime.getRuntime().exec(\"python3 balance.py \" + s );
        BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
        output += in.readLine();
        } catch (Exception e) {
        }
        return output;
    }"
let balance_end = "}" 