using UnityEngine;
using System.Collections;

public class soundcontroller : MonoBehaviour {

    public AudioSource m_AudioSource;
    void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.CompareTag("MyPlayer"))
        {
            m_AudioSource.Play();

         //  Vector3.AngleBetween
        }
    }
}
