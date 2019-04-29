using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AlterSharpness : MonoBehaviour
{
    Renderer render;

    [SerializeField] private Text textMix;
    [SerializeField] private Text textSharp;

    private float x, y;

    void Start()
    {
        x = 0.125f;
        y = 0;
        render = GetComponent<Renderer>();
        render.material.shader = Shader.Find("Custom/BA_Sharpen");
    }

    // Update is called once per frame
    void Update()
    {
        x += Input.GetAxis("Horizontal")/100;
        y += Input.GetAxis("Vertical")/50;

        x = Mathf.Clamp01(x);
        y = Mathf.Clamp(y, 0, 100);

        if(textMix != null)
            textMix.text = "Mix: " + x;
        if(textSharp != null)
            textSharp.text = "Sharpness: " + y;

        render.material.SetFloat("_Mix", x);
        render.material.SetFloat("_LookUpDistance", y);
    }
}
