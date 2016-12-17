using UnityEngine;
using System.Collections;

public class police : MonoBehaviour {

    private GameObject MyPolice;
    public GameObject Enemyobj;
    private Vector3 enemyDir;

    void Awake()
    {
        StartCoroutine(Checkenemy());
    }

    void Update()
    {

    }

    void OnTriggerEnter(Collider col)
    {
        if (col.CompareTag("MyPlayer"))
        {

            Debug.Log("걸림");
            
        }
    }

    private RaycastHit hit = new RaycastHit();
    private Ray ray;

    IEnumerator Checkenemy()
    {

        while (true)
        {
            enemyDir = Enemyobj.transform.position - this.transform.position;
            float angletemp=  Vector3.Angle(this.transform.forward, enemyDir);

            //Debug.Log(angletemp);
            if(angletemp < 60)
            {
                //Debug.DrawRay(this.transform.position, enemyDir, Color.red,30);

                if(Physics.Raycast(this.transform.position, enemyDir, out hit, 30))
                {
                    if (hit.collider.CompareTag("MyPlayer"))
                    {

                        Debug.Log("보고있음");
                    }
                    
                }
                
                /*if (Physics.Raycast(ray, out hit))
                {
                    Transform objectHit = hit.transform;
                }*/

            }

            yield return new WaitForSeconds(0.3f);
        }

        
    }


}
