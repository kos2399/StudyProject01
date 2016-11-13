using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TargetCharacter : MonoBehaviour {

    private NavMeshAgent MyNavAgent;

    public GameObject DesGroup;
    public List<Transform> DesPosObjList;

    private Animator MyAnim;

    public int CurrentPosIndex = 0;
	// Use this for initialization
	void Awake () {
        MyNavAgent = this.GetComponent<NavMeshAgent>();
        MyAnim = this.GetComponent<Animator>();
       // Debug.Log();

        for (int i = 0; i < DesGroup.GetComponentsInChildren<Transform>().Length-1; i++)
        {
           

            DesPosObjList.Add(DesGroup.transform.GetComponentInChildren<Transform>().GetChild(i));
           // DesPosObjList

        }
       
    }

    void SetDestPosition()
    {
        if (CurrentPosIndex >= DesGroup.GetComponentsInChildren<Transform>().Length - 1)
            return;


       
        if (Vector3.Distance(this.transform.position, DesPosObjList[CurrentPosIndex].transform.position)<1f)
        {
            
            CurrentPosIndex++;
        }


        this.MyNavAgent.destination = DesPosObjList[CurrentPosIndex].transform.position;
    }

	// Update is called once per frame
	void Update () {

        SetDestPosition();

        // Debug.Log();
        if (this.MyNavAgent.velocity.magnitude < 0.1f)
        {
            Debug.Log("멈춤");
            MyAnim.SetBool("B_Walk", false);
        }
        else
        {
            MyAnim.SetBool("B_Walk", true);
        }


    }
}
