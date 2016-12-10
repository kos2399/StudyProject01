using UnityEngine;
using System.Collections;

public class camera : MonoBehaviour {

    public Transform target;
    private Transform head;

    // Use this for initialization
    void Awake () {
        head = target.transform.FindChild("Root_jnt").FindChild("Hips_jnt").FindChild("Body_jnt").FindChild("Spine_jnt").FindChild("Head_jnt");
    }
	
	// Update is called once per frame
	void LateUpdate () {
        //Vector3 tmp = new Vector3(target.transform.position.x, target.transform.position.y + 3, target.transform.position.z-10);
        // this.transform.position = tmp; 
        //this.transform.LookAt(target);

        this.transform.forward = head.transform.forward;
    }
}
