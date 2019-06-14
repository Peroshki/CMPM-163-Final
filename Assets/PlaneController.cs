using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// A simple script to give the user control over the terrain settings

public class PlaneController : MonoBehaviour
{
    Renderer rend;
    
    float oX;
    float oY;
    float oZ;
    float scale;
    float freq;

    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Renderer>();

        rend.material.shader = Shader.Find("Custom/GroundNoise");

        oX = 0f;
        oY = 0f;
        oZ = 0f;
        scale = 2f;
        freq = 0.45f;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey("up"))
        {
            oZ += 0.01f;
            rend.material.SetVector("_NoiseOffset", new Vector4(oX, oY, oZ, 0f));
        }
        if (Input.GetKey("down"))
        {
            oZ -= 0.01f;
            rend.material.SetVector("_NoiseOffset", new Vector4(oX, oY, oZ, 0f));
        }
        if (Input.GetKey("left"))
        {
            oX -= 0.01f;
            rend.material.SetVector("_NoiseOffset", new Vector4(oX, oY, oZ, 0f));
        }
        if (Input.GetKey("right"))
        {
            oX += 0.01f;
            rend.material.SetVector("_NoiseOffset", new Vector4(oX, oY, oZ, 0f));
        }
        if (Input.GetKey(","))
        {
            oY -= 0.01f;
            rend.material.SetVector("_NoiseOffset", new Vector4(oX, oY, oZ, 0f));
        }
        if (Input.GetKey("."))
        {
            oY += 0.01f;
            rend.material.SetVector("_NoiseOffset", new Vector4(oX, oY, oZ, 0f));
        }
        if (Input.GetKey("w"))
        {
            scale += 0.01f;
            rend.material.SetFloat("_NoiseScale", scale);
        }
        if (Input.GetKey("s"))
        {
            scale -= 0.01f;
            rend.material.SetFloat("_NoiseScale", scale);
        }
        if (Input.GetKey("a"))
        {
            freq -= 0.001f;
            rend.material.SetFloat("_NoiseFrequency", freq);
        }
        if (Input.GetKey("d"))
        {
            freq += 0.001f;
            rend.material.SetFloat("_NoiseFrequency", freq);
        }
    }
}
