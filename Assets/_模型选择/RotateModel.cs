using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RotateModel : MonoBehaviour
{
    public Transform modelTransform;
    private bool isRotate;

    private Vector3 startPoint;
    private Vector3 startAngel;

    private float rotateScale = 0.5f;
    private List<Button> btnList;
    private List<string> nameList;
    private GameObject currentAnimal;

    // Start is called before the first frame update
    void Start()
    {
        nameList = new List<string>();
        nameList.Add("1");
        nameList.Add("2");
        nameList.Add("3");

        btnList = new List<Button>();
        for (int i = 0; i < 3; i++)
        {
            var btn = GameObject.Find("Canvas/Panel/ButtonsContainer/btn_" + i).GetComponent<Button>();
            btnList.Add(btn);

            btn.onClick.AddListener(() => { LoadAnimal(btn); });
        }
    }

    private void LoadAnimal(Button btn)
    {
        if (currentAnimal != null)
        {
            Destroy(currentAnimal);
        }

        var index = btnList.IndexOf(btn);
        var name = nameList[index];

        var prefab = Resources.Load<GameObject>("Prefabs/" + name);
        var go = Instantiate(prefab);

        go.transform.position = Vector3.zero;
        modelTransform.eulerAngles = Vector3.zero;

        go.transform.SetParent(modelTransform, false);

        currentAnimal = go.gameObject;
    }


    public void BeginDrag()
    {
        isRotate = true;
        startPoint = Input.mousePosition;
        startAngel = modelTransform.eulerAngles;
    }

    public void Drag()
    {
        var currentPoint = Input.mousePosition;
        var x = startPoint.x - currentPoint.x;
        modelTransform.eulerAngles = startAngel + new Vector3(0, x * rotateScale, 0);

    }

    public void EndDrag()
    {
        isRotate = false;
    }
}