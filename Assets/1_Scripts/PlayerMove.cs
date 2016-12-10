using UnityEngine;
using System.Collections;

public class PlayerMove : PlayerControllor {

    private Rigidbody myRigidbody;
    private Transform head;

    public float speed; 
    // Use this for initialization
    void Awake () {
        myRigidbody = this.GetComponent<Rigidbody>();
        head = this.transform.FindChild("Root_jnt").FindChild("Hips_jnt").FindChild("Body_jnt").FindChild("Spine_jnt").FindChild("Head_jnt");

        Debug.Log(head.name);
    }
	
	// Update is called once per frame
	void Update () {
        float h = Input.GetAxis("Horizontal");
        float v = Input.GetAxis("Vertical");

        Vector3 tmp = new Vector3(0, myRigidbody.velocity.y, 0);
        tmp += (this.transform.forward * v * speed) + (this.transform.right * h * speed);
        myRigidbody.velocity = tmp;
        //Debug.Log(tmp);
        //Debug.Log(myRigidbody.velocity);

       
    }



    void LateUpdate()
    {
        axes = RotationAxes.MouseXAndY;
        MouseUpdate(head);
        // axes = RotationAxes.MouseX;
        //MouseUpdate(this.transform);
    }
}
