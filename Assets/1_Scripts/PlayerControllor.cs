using UnityEngine;
using System.Collections;

public class PlayerControllor : MonoBehaviour
{

    public enum RotationAxes { MouseXAndY = 0, MouseX = 1, MouseY = 2 }
    public RotationAxes axes = RotationAxes.MouseXAndY;
    public float sensitivityX = 15F;
    public float sensitivityY = 15F;
    public float minimumX = -90F;
    public float maximumX = 90F;
    public float minimumY = -60F;
    public float maximumY = 60F;
    float rotationY = 0F;
    private float rotationX = 0;
    private float rotateSensX = 1;


    // Use this for initialization
    void Start()
    {
        // Make the rigid body not change rotation
        if (GetComponent<Rigidbody>())
            GetComponent<Rigidbody>().freezeRotation = true;

        // Debug.Log("Start");
    }

    // Update is called once per frame
    protected void MouseUpdate(Transform socket)
    {

        // Debug.Log("rotationY" + rotationY);
        if (axes == RotationAxes.MouseXAndY )
        {
            //rotationX = socket.transform.localEulerAngles.x + Input.GetAxis("Mouse X") * sensitivityX;


            rotationX += Input.GetAxis("Mouse X") * sensitivityX;
            rotationX = Mathf.Clamp(rotationX, minimumX, maximumX);


            rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
            rotationY = Mathf.Clamp(rotationY, minimumY, maximumY);


            socket.transform.localEulerAngles = new Vector3(-rotationX, -rotationY, 0);
        }
        else if (axes == RotationAxes.MouseX )
        {
            socket.transform.Rotate(0, Input.GetAxis("Mouse X") * sensitivityX, 0);
        }
        else
        {
            rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
            rotationY = Mathf.Clamp(rotationY, minimumY, maximumY);

            socket.transform.localEulerAngles = new Vector3(-rotationY, transform.localEulerAngles.y, 0);
        }
    }
}