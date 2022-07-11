using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class UIControl : MonoBehaviour
{
    public PlayerMovement PlayerMovement;

    public needButton up;
    public needButton down;
    public needButton left;
    public needButton right;

    void Start()
    {
        up.down += () => { PlayerMovement.z = 1; };
        up.up += () => { PlayerMovement.z = 0; };

        down.down += () => { PlayerMovement.z = -1; };
        down.up += () => { PlayerMovement.z = 0; };

        left.down += () => { PlayerMovement.x = -1; };
        left.up += () => { PlayerMovement.x = 0; };

        right.down += () => { PlayerMovement.x = 1; };
        right.up += () => { PlayerMovement.x = 0; };


    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
