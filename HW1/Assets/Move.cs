using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move : MonoBehaviour
{
    public Vector3 moveVector = Vector3.one;

    private Vector3 startPos;
    private Vector3 endPos;

    // Start is called before the first frame update
    void Start()
    {
        startPos = transform.position;
        endPos = startPos + moveVector;
    }

    // Update is called once per frame
    void Update()
    {
        float lerpVal = Mathf.Sin(Time.time)/2 + 0.5f;
        //print(lerpVal);
        transform.position = Vector3.Lerp(startPos, endPos, lerpVal);
    }
}
